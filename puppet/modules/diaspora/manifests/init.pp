class diaspora (
  $hostname,
  $environment   = 'development',
  $app_directory = '/home/diaspora',
  $user          = 'diaspora',
  $group         = 'diaspora',
  $db_provider   = 'mysql',
  $db_host       = 'localhost',
  $db_port       = '3306',
  $db_name       = 'diaspora_development',
  $db_username   = 'diaspora',
  $db_password   = 'diaspora',
) {

  class { 'diaspora::dependencies': }
  class { 'diaspora::ruby': }
  class { 'diaspora::user':
    home  => $app_directory,
    user  => $user,
    group => $group
  }

  class { 'diaspora::database':
    db_provider => $db_provider,
    db_host     => $db_host,
    db_port     => $db_port,
    db_name     => $db_name,
    db_username => $db_username,
    db_password => $db_password
  }

  file {
    "$app_directory/shared/config/database.yml":
      content => template('diaspora/database.yml.erb'),
      owner   => $user,
      group   => $group,
      require => Class['diaspora::user'];

    "$app_directory/shared/config/diaspora.yml":
      content => template('diaspora/diaspora.yml.erb'),
      owner   => $user,
      group   => $group,
      require => Class['diaspora::user'];
  }

  if $environment != 'development' {
    file {
      "$app_directory/certs/$hostname.crt":
        source  => "puppet:///modules/diaspora/certs/$hostname.crt",
        owner   => $user,
        group   => $group,
        before  => Class['nginx'];

      "$app_directory/certs/$hostname.key":
        source  => "puppet:///modules/diaspora/certs/$hostname.key",
        owner   => $user,
        group   => $group,
        before  => Class['nginx'];
    }
  }

  class { 'nginx': }

  nginx::resource::upstream { 'diaspora_app':
    ensure  => present,
    members => ['localhost:3000']
  }

  if $environment == 'development' {
    nginx::resource::vhost { $hostname:
      ensure      => present,
      proxy       => 'http://diaspora_app',
    }
  } else {
    nginx::resource::vhost { $hostname:
      ensure      => present,
      proxy       => 'http://diaspora_app',
      ssl         => true,
      ssl_cert    => "$app_directory/certs/$hostname.crt",
      ssl_key     => "$app_directory/certs/$hostname.key",
    }
  }
}
