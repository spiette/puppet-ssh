# == Class ssh::intall
# This class is meant to be called from ssh
# It install requires packages
class ssh::install (
  $autoupdate=false,
  ) {
  include ssh::params
  $ensure = $autoupdate ? {
    false   => present,
    true    => latest,
    default => fail('autoupdate should be true or false')
  }
  package { $ssh::params::pkgname:
    ensure => $ensure,
  }
}
