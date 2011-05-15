module Gitem
  class App < Thor
    include Thor::Actions
    include Gitem::Helper

    ROOT_PATH = FileUtils.pwd
    default_task :list

    desc "pull [USER]", "Update or add all the repos in your list.  Specify Github user to add that user's watched repos to your list"
    method_options :user => :string
    def pull
      profile = Profile.open
      user_name = options[:user] || profile.user 
      if user_name.nil?
        say "No user provided or found in .gitem.yml"
        exit
      end

      remote_repos = Repository.remote_all(user_name)
      remote_repos.each do |repo|
        repo.dir = repo.fork ? "#{repo.name}-#{repo.owner}" : repo.name

        unless profile.ignored.include?(repo.full_name)
          if profile.has_repo?(repo)
            say_status "update repo", repo.full_name, :blue
            inside repo.dir do
              run "git pull"
            end
          else
            say_status "add repo", repo.full_name, :blue
            run "git clone #{repo.url} #{repo.dir}"
            profile.add_repo(repo)
          end
        else
          say_status "ignoring repo", repo.full_name, :blue
        end
      end

      profile.user ||= user_name
      profile.save
    end

    desc "update <REPO>", "Updates the specified repository"
    def update(repo_name)
      owner, name = split_name(repo_name)
      profile = Profile.open
      remote_repo = Repository.remote(owner, name)
      if profile.has_repo?(remote_repo)
        repo = profile.repos.find { |r| r == remote_repo }
        say_status "update repo", repo.full_name, :blue
        inside repo.dir do
          run "git pull"
        end
      else
        say "Repo #{repo_name} not found."
        say "To add: gitem add #{repo_name}"
      end
    end

    desc "add <REPO>", "Add a Github repo, source will be downloaded and added to your list"
    def add(repo_name)
      owner, name = split_name(repo_name)  
      profile = Profile.open
      repo = Repository.remote(owner, name)

      if profile.has_repo?(repo)
        update(repo.full_name)
      else
        repo.dir = repo.fork ? "#{repo.name}-#{repo.owner}" : repo.name

        profile.add_repo(repo)
        say_status "add repo", repo_name, :blue
        run "git clone #{repo.url} #{repo.dir}"
      end
      profile.save
    end

    desc "list", "Show the Github repos in your list"
    method_options :ignored => :boolean
    def list
      profile = Profile.open
      if options.ignored?
        profile.ignored.each do |repo|
          say repo
        end
      else
        profile.repos.each do |repo|
          say repo.full_name
        end
      end
    end

    desc "ignore <REPO>", "Ignore this repo, gitem will no longer try to add or update it"
    def ignore(repo_name)
      profile = Profile.open
      say_status "ignore repo", repo_name, :blue
      profile.ignored << repo_name
      owner, name = split_name(repo_name)
      profile.remove_repo(Repository.new(owner, name))
      profile.save
    end

    desc "remove <REPO>", "Remove repo from gitem list and delete its directory"
    def remove(repo_name)
    end

    desc "user <NAME>", "Change the default Github user"
    def user(name)
      profile = Profile.open
      profile.user = name
      say_status "changing Github user", name, :blue
      profile.save
    end
  end
end
