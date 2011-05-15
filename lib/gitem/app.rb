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
      profile = Profile.open_profile #Profile.open 
      user_name ||= profile.user
      remote_repos = Repository.remote_repos(user_name)

      remote_repos.each do |repo|
        repo.dir = repo.name
        repo.dir = repo.dir +  "-#{repo.owner}" if repo.fork

        unless profile.ignored.include?(repo.full_name)
          if profile.has_repo?(repo)
            say_status "update repo", "#{repo.full_name}", :blue
            inside "#{repo.dir}" do
              run "git pull"
            end
          else
            say_status "add repo", "#{repo.full_name}", :blue
            run "git clone #{repo.url} #{repo.dir}"
            profile.repos << repo 
          end
        else
          say_status "ignoring repo", "#{repo.full_name}", :blue
        end
      end

      profile.user ||= user_name
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

    desc "ignore <REPO>", "Ignore this repo, gitem will no longer try to add or update it"
    def ignore(repo_name)
      profile = Profile.open
      say_status "ignore repo", repo_name, :blue
      profile.ignored << repo_name
      profile.save
    end

    desc "user <NAME>", "Change the default Github user"
    def user(name)
    end
  end
end
