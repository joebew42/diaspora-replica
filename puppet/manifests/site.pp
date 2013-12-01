node 'staging.diaspora.io' {
  class { 'diaspora':
    hostname      => $fqdn,
    environment   => 'production',
    app_directory => '/home/diaspora',
    user          => 'diaspora',
    group         => 'diaspora',
    db_provider   => 'mysql',
    db_host       => 'localhost',
    db_port       => '3306',
    db_name       => 'diaspora_production',
    db_username   => 'diaspora',
    db_password   => 'diaspora'
  }
}
