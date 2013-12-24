class diaspora::database (
  $db_provider      = 'mysql',
  $db_host          = 'localhost',
  $db_port          = '3306',
  $db_name          = 'diaspora_development',
  $db_username      = 'diaspora',
  $db_password      = 'diaspora',
  $db_root_password = 'diaspora_root',
) {

  class { "diaspora::database::db_$db_provider":
    db_host          => $db_host,
    db_port          => $db_port,
    db_name          => $db_name,
    db_username      => $db_username,
    db_password      => $db_password,
    db_root_password => $db_root_password
  }
}
