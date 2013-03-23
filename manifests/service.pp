# == Class ssh::service
# This class is meant to be called from ssh
# It ensure the service is running
class ssh::service {
  include ssh::params
  service { $ssh::params::service:
    ensure => running,
    enable => true,
  }
}
