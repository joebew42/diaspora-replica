set :stage, :development

set :repo_url, 'https://github.com/diaspora/diaspora.git'
set :branch, 'develop'

role :web, %w{development.diaspora.io}
role :app, %w{development.diaspora.io}
role :db,  %w{development.diaspora.io}

ssh_options = {
  keys: %w(ssh_keys/diaspora),
  forward_agent: true,
  auth_methods: %w(publickey password)
}

set :rvm_type, :system
set :rvm_ruby_version, '1.9.3-p448@diaspora'

set :rails_env, 'development'

server 'development.diaspora.io', user: 'diaspora', roles: %w{web app db}, ssh_options: ssh_options
