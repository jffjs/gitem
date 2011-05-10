module Gitem
  class Repository
    attr_accessor :owner, :name, :url, :dir, :fork, :ignore

    def initialize(owner, name, url, dir=nil)
      @owner = owner
      @name = name
      @url = url
      @dir = dir
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
        repo = self.new(r['owner'], r['name'], r['url'])
        repo.fork = r['fork']
        repos << repo
      end
      return repos
    end

    def full_name
      "#{owner}/#{name}"
    end

    def ==(other)
      self.full_name == other.full_name
    end
  end
end
