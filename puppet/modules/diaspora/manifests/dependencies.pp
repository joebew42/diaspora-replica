class diaspora::dependencies (
  $db_provider = 'mysql'
) {
  case $::operatingsystem {
    Ubuntu,Debian: {
      class { 'diaspora::dependencies::ubuntu':
        db_provider => $db_provider
      }
    }
    CentOS,RedHat,Amazon: {
      class { 'diaspora::dependencies::centos':
        db_provider => $db_provider
      }
    }
  }
}
