class { 'diaspora':
  hostname      => 'staging.diaspora.io',
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
