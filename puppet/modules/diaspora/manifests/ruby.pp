class diaspora::ruby (
  $system_user = 'diaspora'
) {

  $rvm_version  = '1.23.3'
  $ruby_version = '1.9.3-p448'
  $gemset       = 'diaspora'

  class { 'rvm':
    version => $rvm_version
  }->
  file { '/etc/rvmrc':
    content => "umask u=rwx,g=rwx,o=rx\nrvm_trust_rvmrcs_flag=1\n",
    require => Class['rvm']
  }->
  rvm_system_ruby { $ruby_version:
    ensure      => 'present',
    default_use => true
  }->
  rvm_gem { "$ruby_version/puppet":
    ensure  => '3.1.1',
  }->
  rvm_gemset { "$ruby_version@$gemset":
    ensure  => present,
  }->
  rvm::system_user { "$system_user": }
}
