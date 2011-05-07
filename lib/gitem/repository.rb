module Gitem
  class Repository
    attr_accessor :owner, :name, :url, :dir, :fork

    def initialize(owner, name, url, dir=nil, fork=nil)
      @owner = owner
      @name = name
      @url = url
      @dir = dir
      @fork = fork
    end

    def self.local_repos(profile)
      repos = []
      profile.repos.each do |r| 
        repos << self.new(r['owner'], r['name'], r['url'], r['dir'])  
      end
      return repos
    end

    def self.remote_repos(user)
      remote_data = Gitem::API.watched_repos(user)['repositories']
      repos = []
      remote_data.each do |r|
        repos << self.new(r['owner'], r['name'], r['url'], r['fork'])
      end
      return repos
    end

    def add
    end

    def update
    end
  end
end
