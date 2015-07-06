node 'development.diaspora.local' {
  class { 'diaspora':
    hostname            => $fqdn,
    environment         => 'development',
    rvm_version         => '1.26.11',
    ruby_version        => '2.2',
    app_directory       => '/home/diaspora',
    user                => 'diaspora',
    group               => 'diaspora',
    db_provider         => 'mysql',
    db_host             => 'localhost',
    db_port             => '3306',
    db_name             => 'diaspora_development',
    db_username         => 'diaspora',
    db_password         => 'diaspora',
    db_root_password    => 'diaspora_root',
    unicorn_worker      => 4,
    sidekiq_concurrency => 5,
    sidekiq_retry       => 10,
    sidekiq_namespace   => 'diaspora'
  }
}

node 'production.diaspora.local' {
  class { 'diaspora':
    hostname            => $fqdn,
    environment         => 'production',
    rvm_version         => '1.26.11',
    ruby_version        => '2.1.5',
    app_directory       => '/home/diaspora',
    user                => 'diaspora',
    group               => 'diaspora',
    db_provider         => 'mysql',
    db_host             => 'localhost',
    db_port             => '3306',
    db_name             => 'diaspora_production',
    db_username         => 'diaspora',
    db_password         => 'diaspora',
    db_root_password    => 'diaspora_root',
    unicorn_worker      => 4,
    sidekiq_concurrency => 5,
    sidekiq_retry       => 10,
    sidekiq_namespace   => 'diaspora'
  }
}
