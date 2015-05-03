set :stage, :production

set :repo_url, 'https://github.com/diaspora/diaspora.git'
set :branch, 'master'

# Uncomment to enable postgresql support
# set :default_env, { DB: 'postgres' }

role :web, %w{production.diaspora.local}
role :app, %w{production.diaspora.local}
role :db,  %w{production.diaspora.local}

ssh_options = {
  keys: %w(ssh_keys/diaspora),
  forward_agent: true,
  auth_methods: %w(publickey password)
}

set :rvm_type, :system
set :rvm_ruby_version, '2.1.5@diaspora'

set :rails_env, 'production'

server 'production.diaspora.local', user: 'diaspora', roles: %w{web app db}, ssh_options: ssh_options
