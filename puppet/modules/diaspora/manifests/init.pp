class diaspora (
  $hostname         = 'development.diaspora.local',
  $environment      = 'development',
  $rvm_version      = '1.25.14',
  $ruby_version     = '1.9.3-p448',
  $app_directory    = '/home/diaspora',
  $user             = 'diaspora',
  $group            = 'diaspora',
  $db_provider      = 'mysql',
  $db_host          = 'localhost',
  $db_port          = '3306',
  $db_name          = 'diaspora_development',
  $db_username      = 'diaspora',
  $db_password      = 'diaspora',
  $db_root_password = 'diaspora_root',
) {

  class { 'diaspora::dependencies':
    db_provider => $db_provider
  }->
  class { 'diaspora::user':
    home  => $app_directory,
    user  => $user,
    group => $group
  }->
  class { 'diaspora::ruby':
    system_user  => $user,
    rvm_version  => $rvm_version,
    ruby_version => $ruby_version
  }->
  class { 'diaspora::database':
    environment      => $environment,
    db_provider      => $db_provider,
    db_host          => $db_host,
    db_port          => $db_port,
    db_name          => $db_name,
    db_username      => $db_username,
    db_password      => $db_password,
    db_root_password => $db_root_password
  }->
  class { 'diaspora::webserver':
    environment   => $environment,
    hostname      => $hostname,
    app_directory => $app_directory
  }->
  file {
    "${app_directory}/shared/config/database.yml":
      content => template('diaspora/database.yml.erb'),
      owner   => $user,
      group   => $group;

    "${app_directory}/shared/config/diaspora.yml":
      content => template('diaspora/diaspora.yml.erb'),
      owner   => $user,
      group   => $group;
  }
}
