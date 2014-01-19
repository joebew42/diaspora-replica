class diaspora::database::db_postgres (
  $environment      = 'development',
  $db_host          = 'localhost',
  $db_port          = '5432',
  $db_name          = 'diaspora_development',
  $db_username      = 'diaspora',
  $db_password      = 'diaspora',
  $db_root_password = 'diaspora_root',
) {

  group { 'postgres':
    ensure => present,
  }->
  user { 'postgres':
    ensure => present,
    gid    => 'postgres',
    shell  => '/bin/bash',
    home   => '/var/lib/postgresql',
  }->
  file { '/var/lib/postgresql':
    ensure => 'directory',
    owner  => 'postgres',
    group  => 'postgres'
  }->
  class { 'postgresql::globals':
    version             => '9.1',
    manage_package_repo => true,
    encoding            => 'UTF8',
    locale              => 'en_US.UTF-8'
  }->
  class { 'postgresql::server':
    ensure           => 'present',
    listen_addresses => '*'
  }

  $superuser = $environment == 'development'

  postgresql::server::role { $db_username:
    superuser => $superuser,
    password_hash => postgresql_password($db_username, $db_password)
  }->
  postgresql::server::db { $db_name:
    user     => $db_username,
    password => postgresql_password($db_username, $db_password),
  }
}
