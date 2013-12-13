set :application, 'diaspora'

set :deploy_to, '/home/diaspora'
set :scm, :git

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/database.yml config/diaspora.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5

set :unicorn_config, "config/unicorn.rb"
set :unicorn_pid, "#{fetch :deploy_to}/current/tmp/pids/unicorn.pid"

namespace :deploy do

  desc "Assets precompile"
  task :compile_assets do
    on roles(:app), in: :parallel do
      within(current_path) do
        info 'compiling assets ...'
        execute :bundle, "exec rake assets:precompile"
      end
    end
  end

  desc "Start"
  task :start do
    on roles(:app), in: :parallel do
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

  desc "Stop"
  task :stop do
    on roles(:app), in: :parallel do
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

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Report Uptimes"
  task :uptime do
    on roles(:app) do
      info "Host uptime:\t#{capture(:uptime)}"
    end
  end

  before :compile_assets, 'rvm:hook'
  before :start, 'rvm:hook'
  after :finishing, 'deploy:cleanup'

end
