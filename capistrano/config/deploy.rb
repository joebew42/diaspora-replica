set :application, 'diaspora'
set :repo_url, 'https://github.com/diaspora/diaspora.git'
set :branch, 'master'

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
  task :assets_precompile do
    on roles(:app), in: :parallel do
      within(current_path) do
        execute :echo, "Precompiling assets ..."
        execute :bundle, "exec rake assets:precompile"
      end
    end
  end

  desc "Start"
  task :start do
    on roles(:app), in: :parallel do
      within(current_path) do
        execute :echo, "Starting unicorn ..."
        execute :bundle, "exec unicorn_rails -p 3000 -c #{fetch :unicorn_config} -E #{fetch :rails_env} -D"
      end
    end
  end

  desc "Stop"
  task :stop do
    on roles(:app), in: :parallel do
      if test("[ -f #{fetch :unicorn_pid} ]")
        execute :echo, "Stopping unicorn ..."
        execute :kill, "`cat #{fetch :unicorn_pid}`"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke :stop
      invoke :start
    end
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

  before :assets_precompile, 'rvm:hook'
  before :start, 'rvm:hook'
  after :finishing, 'deploy:cleanup'

end
