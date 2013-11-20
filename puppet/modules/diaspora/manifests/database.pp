class diaspora::database (
  $db_provider = 'mysql',
  $db_host     = 'localhost',
  $db_port     = '3306',
  $db_name     = 'diaspora_development',
  $db_username = 'diaspora',
  $db_password = 'diaspora'
) {

  $mysql_root_password = 'root'

  package { 'mysql-server':
   ensure => 'installed'
  }

  exec { 'mysql_root_password':
   subscribe   => Package['mysql-server'],
   refreshonly => true,
   unless      => "mysqladmin -uroot -p$mysql_root_password status",
   path        => "/bin:/usr/bin",
   command     => "mysqladmin -uroot password $mysql_root_password",
  }

  exec { 'db_create':
   require => Exec['mysql_root_password'],
   unless  => "mysql -uroot -p$mysql_root_password -e \"USE '$db_name'\";",
   path    => "/bin:/usr/bin",
   command => "mysql -uroot -p$mysql_root_password -e \"CREATE DATABASE $db_name\";",
  }

  exec { 'db_user':
    require => Exec['db_create'],
    unless  => "mysql -u$db_name -p$db_password",
    path    => "/bin:/usr/bin",
    command => "mysql -uroot -p$mysql_root_password -e \"GRANT ALL PRIVILEGES ON $db_name.* TO '$db_username'@'$db_host' IDENTIFIED BY '$db_password'\";"
  }
}
