set :stage, :development

set :repo_url, 'https://github.com/diaspora/diaspora.git'
set :branch, 'develop'

role :web, %w{development.diaspora.local}
role :app, %w{development.diaspora.local}
role :db,  %w{development.diaspora.local}

ssh_options = {
  keys: %w(ssh_keys/diaspora),
  forward_agent: true,
  auth_methods: %w(publickey password)
}

set :rvm_type, :system
set :rvm_ruby_version, '2.2@diaspora'

set :rails_env, 'development'
set :bundle_without, []

set :assets_roles, [:none] # No assets compile for development

set :keep_releases, 1

server 'development.diaspora.local', user: 'diaspora', roles: %w{web app db}, ssh_options: ssh_options
