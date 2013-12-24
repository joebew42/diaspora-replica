class diaspora::dependencies::ubuntu (
  $db_provider = 'mysql'
) {

  if ! defined(Package['build-essential'])      { package { 'build-essential':      ensure => present } }
  if ! defined(Package['git'])                  { package { 'git':                  ensure => present } }
  if ! defined(Package['imagemagick'])          { package { 'imagemagick':          ensure => present } }
  if ! defined(Package['nodejs'])               { package { 'nodejs':               ensure => present } }
  if ! defined(Package['redis-server'])         { package { 'redis-server':         ensure => present } }
  if ! defined(Package['libcurl4-openssl-dev']) { package { 'libcurl4-openssl-dev': ensure => present } }
  if ! defined(Package['libxml2-dev'])          { package { 'libxml2-dev':          ensure => present } }
  if ! defined(Package['libxslt-dev'])          { package { 'libxslt-dev':          ensure => present } }
  if ! defined(Package['libmagickwand-dev'])    { package { 'libmagickwand-dev':    ensure => present } }

  if $db_provider == 'mysql' and !defined(Package['libmysqlclient-dev']) {
    package { 'libmysqlclient-dev':
      ensure => present
    }
  }

  if $db_provider == 'postgres' and !defined(Package['libpq-dev']) {
    package { 'libpq-dev':
      ensure => present
    }
  }
}
