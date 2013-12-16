set :stage, :staging

set :repo_url, 'https://github.com/diaspora/diaspora.git'
set :branch, 'master'

role :web, %w{staging.diaspora.local}
role :app, %w{staging.diaspora.local}
role :db,  %w{staging.diaspora.local}

ssh_options = {
  keys: %w(ssh_keys/diaspora),
  forward_agent: true,
  auth_methods: %w(publickey password)
}

set :rvm_type, :system
set :rvm_ruby_version, '1.9.3-p448@diaspora'

set :rails_env, 'production'

server 'staging.diaspora.local', user: 'diaspora', roles: %w{web app db}, ssh_options: ssh_options
