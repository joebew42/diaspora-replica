set :stage, :staging

role :web, %w{diaspora.localhost.com}
role :app, %w{diaspora.localhost.com}
role :db,  %w{diaspora.localhost.com}

ssh_options = {
  keys: %w(ssh_keys/diaspora),
  forward_agent: true,
  auth_methods: %w(publickey password)
}

set :rvm_type, :system
set :rvm_ruby_version, '1.9.3-p448@diaspora'

set :rails_env, 'development'

server 'diaspora.localhost.com', user: 'diaspora', roles: %w{web app db}, ssh_options: ssh_options
