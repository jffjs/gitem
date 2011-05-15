module Gitem
  class Profile
    extend Gitem::Helper

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

          repo_data = profile_data['repositories'] || Array.new
          repo_data.each do |r|
            owner, name = split_name(r['name'])
            profile.add_repo(Repository.new(owner, name, :url => r['url'], 
                                                         :dir => r['directory']))
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
      @repos.each do |repo|
        repos << { 'name' => repo.full_name,
                   'url'  => repo.url,
                   'directory' => repo.dir }
      end
      profile_data = { 'user'         => @user, 
                       'repositories' => (repos unless repos.empty?),
                       'ignored'      => (@ignored unless @ignored.empty?) }
      Profile.write_yaml(profile_data)
    end

    def add_repo(repo)
      @repos << repo
    end

    def remove_repo(repo)
      @repos.delete(repo)
    end

    def has_repo?(repo)
      found = @repos.find { |r| r.full_name == repo.full_name }
      if found 
        File.exists?(found.dir)
      end
    end

    def ignored?(repo_name)
      ignored.each do |i|
        regex = Regexp.compile("^#{i}")
        return true if regex =~ repo_name
      end
      false
    end
  end
end
