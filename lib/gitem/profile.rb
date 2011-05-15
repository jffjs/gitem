module Gitem
  class Profile

    YAML_PATH = File.join(App::ROOT_PATH, ".gitem.yml")
    
    attr_accessor :user, :repos, :ignored

    def initialize
      @repos = [] 
      @ignored = []
    end

    class << self
      def open
        profile_data = read_yaml 

        if profile_data
          profile = Profile.new

          profile.user = profile_data['user']
          profile.ignored = profile_data['ignored'] || Array.new

          profile_data['repositories'].each do |r|
            owner, name = r['name'].split(/\//)
            profile.repos << Repository.new(owner, name, r['url'], r['dir'])
          end
        end

        profile || Profile.new
      end

      def read_yaml(path=nil)
        path ||= YAML_PATH
        YAML::load(File.open path) if File.exists?(path)
      end

      def write_yaml(profile_data, path=nil)
        path ||= YAML_PATH
        File.open(path, 'w') do |f|
          f.write profile_data.to_yaml
        end
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
                       'repositories' => (repos unless repos.empty?),
                       'ignored'      => (@ignored unless @ignored.empty?) }
      Profile.write_yaml(profile_data)
    end

    def saved?
      File.exists?(YAML_PATH)
    end

    def has_repo?(repo)
      @repos.include?(repo) && File.exists?(repo.dir)
    end
  end
end
