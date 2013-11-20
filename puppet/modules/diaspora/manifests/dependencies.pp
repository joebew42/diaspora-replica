class diaspora::dependencies {
  case $::operatingsystem {
    Ubuntu,Debian: { require diaspora::dependencies::ubuntu }
    #CentOS,RedHat,Amazon: { require diaspora::dependencies::centos }
  }
}
