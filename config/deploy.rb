require 'bundler/capistrano'

# Application
set :application, 'ibs-brokerage'

# Deploy configuration
set :deploy_server,   "hydrogen.locum.ru"
set :user, 'hosting_mazichka'
set :login,  'mazichka'
set :use_sudo, false

set :deploy_to,       "/var/www/home/hosting_mazichka/projects/ibs-brokerage"
set :unicorn_conf,    "/etc/unicorn/#{application}.#{login}.rb"
set :unicorn_pid,     "/var/run/unicorn/#{user}/#{application}.#{login}.pid"
set :bundle_dir,      File.join(fetch(:shared_path), 'gems')

set :shared_children, shared_children + %w[tmp/sockets public/uploads]
set :shared_configs, %w[database.yml]

# Следующие строки необходимы, т.к. ваш проект использует rvm.
set :rvm_ruby_string, "2.1.5"
set :rake,            "rvm use #{rvm_ruby_string} do bundle exec rake" 
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"

# VCS Configuration
#set :scm, :git
#set :repository, 'git@github.com:demiazz/princess.git'
#set :branch, 'master'
#set :deploy_via, :remote_cache

# SSH configs
#set :ssh_options, forward_agent: true
#set :normalize_asset_timestamps, false

# Rails env
set :rails_env, 'production'

# Unicorn configuration
set :unicorn_config, 'production'

# Releases Config
set :keep_releases, 5

# Deploy configuration
# If can, use absolute paths
#set :deploy_to, lambda { capture("echo -n ~/") }
set :domain_name, 'hydrogen.locum.ru'

# Database config
#set :db_name, 'princess'
#set :db_user, 'princess'
#set :db_password, 'r63g47&h3f4g67w5dc^5c75faw4e5463q'

# HTTP Auth for admin
#set :http_auth_enabled, true
#set :http_auth_name, 'princess-admin'
#set :http_auth_password, 'd87G76g823d2^GG$'

server domain_name, :web, :app, :db, primary: true

# rbenv
#default_run_options[:shell] = '/bin/bash --login'

# Deploy tasks
namespace :deploy do

  desc "Zero-downtime restart of Unicorn"
  task :restart, roles: :app, except: { no_release: true } do
    run "kill -s USR2 `cat #{shared_path}/pids/unicorn.pid`"
  end

  desc "Start unicorn"
  task :start, roles: :app, except: { no_release: true } do
    run "cd #{current_path}; bundle exec unicorn -c config/unicorn.rb -E #{rails_env} -D"
  end

  desc "Stop unicorn"
  task :stop, roles: :app, except: { no_release: true } do
    run "kill -s QUIT `cat #{shared_path}/pids/unicorn.pid`"
  end

end

# Config management
namespace :config do

  desc "Create symlinks to shared configs"
  task :symlink, roles: :app do
    shared_configs.each do |config|
      run "ln -nfs #{shared_path}/config/#{config} #{release_path}/config/#{config}"
    end
  end

end

after 'deploy:finalize_update', 'config:symlink'

after 'deploy', 'deploy:cleanup'
after 'deploy:cold', 'deploy:cleanup'

require './config/boot'
