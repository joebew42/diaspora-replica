node 'development.diaspora.io' {
  class { 'diaspora':
    hostname      => $fqdn,
    environment   => 'development',
    app_directory => '/home/diaspora',
    user          => 'diaspora',
    group         => 'diaspora',
    db_provider   => 'mysql',
    db_host       => 'localhost',
    db_port       => '3306',
    db_name       => 'diaspora_development',
    db_username   => 'diaspora',
    db_password   => 'diaspora'
  }
}
