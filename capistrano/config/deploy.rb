set :application, 'diaspora'

set :deploy_to, '/home/diaspora'
set :scm, :git

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/database.yml config/diaspora.yml config/eye.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :keep_releases, 5

set :default_env, { DB: 'all' }
set :bundle_flags, "--with mysql postgresql" # add "--deployment"

namespace :deploy do
  after :finishing, 'deploy:cleanup'
end
