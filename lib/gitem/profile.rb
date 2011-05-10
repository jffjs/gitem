module Gitem
  class Profile

    YAML_PATH = File.join(App::ROOT_PATH, ".gitem.yml")
    
    attr_accessor :user, :repos, :ignored

    def initialize
      profile_exists = open_profile
      unless profile_exists
        @repos = []
        @ignored = []
      end
    end

    def self.open
      if File.exists?(YAML_PATH)
        profile_data = YAML::load(File.open YAML_PATH)

        repos = []
        profile_data['repositories'].each do |r|
          owner, name = r['name'].split(/\//)
          repos << Repository.new(owner, name, r['url'], r['dir'])
        end

        self.new(profile_data['user'], 
                 repos,
                 profile_data['ignored'])
      else
        self.new
      end
    end

    def save
      repos = []
      @repos.map do |repo|
        repos << { 'name' => repo.full_name,
                   'url'  => repo.url,
                   'directory' => repo.dir }
      end
      profile_data = { 'user'         => @user, 
                       'repositories' => repos,
                       'ignored'      => @ignored }
      File.open(YAML_PATH, 'w') do |f|
        f.write profile_data.to_yaml
      end
    end


    def has_repo?(repo)
      @repos.include?(repo) && File.exists?(repo.dir)
    end

    private

    def open_profile
      profile_data = read_yaml 
      if profile_data
        @user = profile_data['user']
        @ignored = profile_data['ignored']
        @repos = []

        profile_data['repositories'].each do |r|
          owner, name = r['name'].split(/\//)
          @repos << Repository.new(owner, name, r['url'], r['dir'])
        end
      end
    end

    def read_yaml
      YAML::load(File.open YAML_PATH) if File.exists?(YAML_PATH)
    end
  end
end
