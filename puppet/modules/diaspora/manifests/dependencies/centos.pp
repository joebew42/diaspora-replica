class diaspora::dependencies::centos (
  $db_provider = 'mysql'
) {

  if ! defined(Package['tar'])                  { package { 'tar':                ensure => present } }
  if ! defined(Package['automake'])             { package { 'automake':           ensure => present } }
  if ! defined(Package['net-tools'])            { package { 'net-tools':          ensure => present } }
  if ! defined(Package['libffi-devel'])         { package { 'libffi-devel':       ensure => present } }
  if ! defined(Package['libxslt-devel'])        { package { 'libxslt-devel':      ensure => present } }
  if ! defined(Package['tcl'])                  { package { 'tcl':                ensure => present } }
  if ! defined(Package['redis'])                { package { 'redis':              ensure => present } }
  if ! defined(Package['npm'])                  { package { 'npm':                ensure => present } }

  if $db_provider == 'mysql' {
    if ! defined(Package['mysql-devel'])        { package { 'mysql-devel':        ensure => present } }
  }

  if $db_provider == 'postgres' {
    if ! defined(Package['postgresql-devel'])   { package { 'postgresql-devel':   ensure => present } }
  }
}
