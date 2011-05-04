module Gitem
  class App < Thor

    desc "test", "test task"
    def test
      puts Gitem::API.watched_repos("jffjs")
    end
  end
end
