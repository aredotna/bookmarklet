require 'pry'
require 'broach'

CAMPFIRE_TOKEN = "2d1febae9d0c53fa7e32f69b009a58bb26300c5d"
CAMPFIRE_ROOM = "HACKER HAVEN"
CAMPFIRE_SUBDOMAIN = "arena"

Broach.settings = {
  'account' => CAMPFIRE_SUBDOMAIN,
  'token'   => CAMPFIRE_TOKEN,
  'use_ssl' => true
}

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash'
ssh_options[:keys] = ["~/.ssh/arena-redis.pem"]

set :application, "Arena"
set :repository,  "git@github.com:arenahq/bookmarklet.git"

set :user, "ec2-user"
set :scm, :git
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :use_sudo, false

role :web, "54.243.223.202"
role :app, "54.243.223.202"

before "deploy:setup", "setup:set_variables"
before "deploy", "deploy:setup"

after "deploy", "deploy:build"
after "deploy:restart", "deploy:cleanup"
# after "deploy:build", "deploy:ping_campfire"

namespace :deploy do
  task :build, :roles => :web do
    run "chmod +x /var/www/marklet/#{branch_name}/current/bin/build"
    run "/var/www/marklet/#{branch_name}/current/bin/build #{branch_name}"
  end

  task :ping_campfire do 
    text = ":love_letter: Bookmarklet Branch just deployed to http://marklet.are.na/#{branch_name} :love_letter: #{message}"
    Broach.speak CAMPFIRE_ROOM, text
  end
end

namespace :setup do 
  task :set_variables do
    unless exists? :branch
      message = "\t\nPlease specify a branch to deploy\t\ncap deploy -S branch=<BRANCH>"
      puts "\e[#{31}m#{message}\e[0m"
      exit
    end

    set :branch, branch

    if exists? :m
      set :message, ' — ' + m
    else 
      set :message, ''
    end
    
    set :branch_name, branch.gsub('/', '-')
    set :deploy_to, "/var/www/marklet/#{branch_name}"

  end
end


