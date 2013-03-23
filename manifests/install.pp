# == Class ssh::intall
# This class is meant to be called from ssh
# It install requires packages
class ssh::install {
  include ssh::params
  package { $ssh::params::pkgname:
    ensure => present,
  }
}
