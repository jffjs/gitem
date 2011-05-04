module Gitem
  class API
    include HTTParty

    base_uri 'http://github.com/api/v2/json'

    def self.watched_repos(user)
      get("/repos/watched/#{user}")
    end

    def self.repo(user, repo_name)
      get("/repos/show/#{user}/#{repo_name}")
    end
  end
end
