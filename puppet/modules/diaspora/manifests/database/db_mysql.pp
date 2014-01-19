class diaspora::database::db_mysql (
  $environment      = 'development',
  $db_host          = 'localhost',
  $db_port          = '3306',
  $db_name          = 'diaspora_development',
  $db_username      = 'diaspora',
  $db_password      = 'diaspora',
  $db_root_password = 'diaspora_root',
) {

  $mysql_service_name = $operatingsystem ? {
    /(Ubuntu|Debian)/         => 'mysql',
    /(CentOS|RedHat|Amazon)/  => 'mysqld',
    default                   => 'mysqld',
  }

  package { 'mysql-server':
   ensure => 'installed'
  }->
  service { 'mysql-server':
    name        => $mysql_service_name,
    ensure      => 'running',
    hasrestart  => 'true',
    hasstatus   => 'true',
  }->
  exec { 'mysql_root_password':
   subscribe   => Package['mysql-server'],
   refreshonly => true,
   unless      => "mysqladmin -uroot -p${db_root_password} status",
   path        => "/bin:/usr/bin",
   command     => "mysqladmin -uroot password ${db_root_password}",
  }->
  exec { 'db_create':
   unless  => "mysql -uroot -p${db_root_password} -e \"USE '${db_name}'\";",
   path    => "/bin:/usr/bin",
   command => "mysql -uroot -p${db_root_password} -e \"CREATE DATABASE ${db_name}\";",
  }->
  exec { 'db_user':
    unless  => "mysql -u${db_name} -p${db_password}",
    path    => "/bin:/usr/bin",
    command => "mysql -uroot -p${db_root_password} -e \"GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_username}'@'${db_host}' IDENTIFIED BY '${db_password}'\";"
  }

  if $environment == 'development' {
    exec { 'db_user_test':
      unless  => "mysql -u${db_name} -p${db_password}",
      path    => "/bin:/usr/bin",
      command => "mysql -uroot -p${db_root_password} -e \"GRANT ALL PRIVILEGES ON diaspora_test.* TO '${db_username}'@'${db_host}' IDENTIFIED BY '${db_password}'\";",
      require => Exec['db_user']
    }
  }
}
