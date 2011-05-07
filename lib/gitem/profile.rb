module Gitem
  class Profile

    YAML_PATH = File.join(App::ROOT_PATH, ".gitem.yml")
    
    attr_accessor :user, :repos

    def initialize(user=nil, repos=nil)
      @user = user
      @repos = repos || []
    end

    def save
      profile_data = { 'user' => @user, 'repositories' => @repos }
      File.open(YAML_PATH, 'w') do |f|
        f.write profile_data.to_yaml
      end
    end

    def self.open
      if File.exists?(YAML_PATH)
        profile_data = YAML::load(File.open YAML_PATH)
        self.new(profile_data['name'], profile_data['repositories'])
      else
        self.new
      end
    end

    def has_repo?(repo)
      result = false
      @repos.each do |r|
        if r['name'] == repo.name && File.exists?(repo.dir)
          result = true 
        end
      end
      return result
    end
  end
end
