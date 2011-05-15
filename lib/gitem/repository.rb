module Gitem
  class Repository
    include Gitem::Helper
    attr_accessor :owner, :name, :url, :dir, :fork

    def initialize(owner, name, options={})
      @owner = owner
      @name = name
      @url = options[:url]
      @dir = options[:dir]
      @fork = options[:fork]
    end

    class << self
      def remote(owner, name)
        r = Gitem::API.repo(owner, name)['repository']
        repo = self.new(r['owner'], r['name'], :url  => r['url'],
                                               :fork => r['fork'])
      end

      def remote_all(user)
        remote_data = Gitem::API.watched_repos(user)['repositories']
        repos = []
        remote_data.each do |r|
          repo = self.new(r['owner'], r['name'], :url  => r['url'],
                                                 :fork => r['fork'])
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
