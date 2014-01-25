set :application, 'diaspora'

set :deploy_to, '/home/diaspora'
set :scm, :git

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/database.yml config/diaspora.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5

set :unicorn_pid, "#{fetch :deploy_to}/current/tmp/pids/unicorn.pid"
set :unicorn_config_path, 'config/unicorn.rb'
set :unicorn_options, "-l0.0.0.0:3000 -P#{fetch :unicorn_pid}"

namespace :deploy do

  desc 'Start application'
  task :start do
    invoke 'unicorn:start'
  end

  desc 'Stop application'
  task :stop do
    invoke 'unicorn:stop'
  end

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :finishing, 'deploy:cleanup'

end
