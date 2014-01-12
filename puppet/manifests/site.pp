node 'development.diaspora.local' {
  class { 'diaspora':
    hostname         => $fqdn,
    environment      => 'development',
    app_directory    => '/home/diaspora',
    user             => 'diaspora',
    group            => 'diaspora',
    db_provider      => 'mysql',
    db_host          => 'localhost',
    db_port          => '3306',
    db_name          => 'diaspora_development',
    db_username      => 'diaspora',
    db_password      => 'diaspora',
    db_root_password => 'diaspora_root'
  }
}

node 'staging.diaspora.local' {
  class { 'diaspora':
    hostname         => $fqdn,
    environment      => 'production',
    app_directory    => '/home/diaspora',
    user             => 'diaspora',
    group            => 'diaspora',
    db_provider      => 'mysql',
    db_host          => 'localhost',
    db_port          => '3306',
    db_name          => 'diaspora_production',
    db_username      => 'diaspora',
    db_password      => 'diaspora',
    db_root_password => 'diaspora_root'
  }
}

node 'production.diaspora.local' {
  class { 'diaspora':
    hostname         => $fqdn,
    environment      => 'production',
    app_directory    => '/home/diaspora',
    user             => 'diaspora',
    group            => 'diaspora',
    db_provider      => 'mysql',
    db_host          => 'localhost',
    db_port          => '3306',
    db_name          => 'diaspora_production',
    db_username      => 'diaspora',
    db_password      => 'diaspora',
    db_root_password => 'diaspora_root'
  }
}
