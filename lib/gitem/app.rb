module Gitem
  class App < Thor
    include Thor::Actions
    ROOT_PATH = FileUtils.pwd
    default_task :test

    desc "test", "test task"
    def test
      say ROOT_PATH
    end

    desc "pull [USER]", "Update or add all the repos in your list.  Specify Github user to add that user's watched repos to your list"
    def pull(user_name=nil)
      profile = Profile.open 
      remote_repos = Gitem::API.watched_repos(user_name)['repositories']

      remote_repos[5..7].each do |repo|
        unless profile.has_repo?(repo['name'])
          say_status "add repo", "#{repo['owner']}/#{repo['name']}", :blue
          run "git clone #{repo['url']}"
          profile.repos <<  { 'owner' => repo['owner'],
                              'name'  => repo['name'],
                              'url'   => repo['url'] }
        else
          # update repo
        end
      end

      profile.save
    end

    desc "update <REPO>", "Updates the specified repository"
    def update(repo_name)
    end

    desc "add <REPO>", "Add a Github repo, source will be downloaded and added to your list"
    def add(repo_name)
      user, repo = repo_name.split(/\//)
      repo_url = Gitem::API.repo(user,repo)["repository"]["url"]
      say_status "add repo", repo_name, :blue
      run "git clone #{repo_url}"
    end

    desc "list", "Show the Github repos in your list"
    def list
    end

    desc "remove <REPO>", "Remove a repo from your list"
    def remove(repo_name)
    end

    desc "user <NAME>", "Change the default Github user"
    def user(name)
    end
  end
end
