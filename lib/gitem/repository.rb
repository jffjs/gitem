module Gitem
  class Repository
    attr_accessor :owner, :name, :url, :dir, :fork, :ignore

    def initialize(owner, name, url, dir=nil)
      @owner = owner
      @name = name
      @url = url
      @dir = dir
    end

    class << self
      def remote(owner, name)
        remote_data = Gitem::API.repo(owner, name)['repository']
        repo = self.new(r['owner'], r['name'], r['url'])
        repo.fork = r['fork']
        return repo
      end

      def remote_all(user)
        remote_data = Gitem::API.watched_repos(user)['repositories']
        repos = []
        remote_data.each do |r|
          repo = self.new(r['owner'], r['name'], r['url'])
          repo.fork = r['fork']
          repos << repo
        end
        return repos
      end
    end

    def full_name
      "#{owner}/#{name}"
    end

    def ==(other)
      self.full_name == other.full_name
    end
  end
end
