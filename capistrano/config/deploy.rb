set :application, 'diaspora'

set :deploy_to, '/home/diaspora'
set :scm, :git

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/database.yml config/diaspora.yml}

set :keep_releases, 5

set :unicorn_config, 'config/unicorn.rb'
set :unicorn_pid, "#{fetch :deploy_to}/current/tmp/pids/unicorn.pid"

namespace :deploy do

  before :compile_assets, 'rvm:hook'

  desc 'Start'
  task :start do
    on roles(:app) do
      within(current_path) do
        if test("[ -e #{fetch :unicorn_pid} ]")
          info 'unicorn is already running ...'
        else
          info 'starting unicorn ...'
          execute :bundle, "exec unicorn_rails -p 3000 -c #{fetch :unicorn_config} -E #{fetch :rails_env} -D"
        end
      end
    end
  end
  before :start, 'rvm:hook'

  desc 'Stop'
  task :stop do
    on roles(:app) do
      if test("[ -e #{fetch :unicorn_pid} ]")
        info 'stopping unicorn ...'
        execute :kill, "`cat #{fetch :unicorn_pid}`"
        execute :rm, fetch(:unicorn_pid)
      else
        info 'unicorn is not running.'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    invoke 'deploy:stop'
    invoke 'deploy:start'
  end

  after :finishing, 'deploy:cleanup'
end
