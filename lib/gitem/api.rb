module Gitem
  class API
    include HTTParty

    base_uri 'http://github.com/api/v2/json'

    class << self
      def watched_repos(user)
        get("/repos/watched/#{user}")
      end

      def repo(user, repo_name)
        get("/repos/show/#{user}/#{repo_name}").parsed_response
      end
    end
  end
end
