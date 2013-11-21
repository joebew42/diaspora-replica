set :stage, :staging

role :web, %w{staging.diaspora.io}
role :app, %w{staging.diaspora.io}
role :db,  %w{staging.diaspora.io}

ssh_options = {
  keys: %w(ssh_keys/diaspora),
  forward_agent: true,
  auth_methods: %w(publickey password)
}

set :rvm_type, :system
set :rvm_ruby_version, '1.9.3-p448@diaspora'

set :rails_env, 'production'

server 'staging.diaspora.io', user: 'diaspora', roles: %w{web app db}, ssh_options: ssh_options
