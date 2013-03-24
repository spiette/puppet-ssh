# == Class: ssh::client
#
# This class will configure ssh client.
#
# === Parameters
#
# Parameters are provided by the ssh class. They can be set in the $options
# associative array.
#
# [*options*]
#   This hash contains ssh_config options. It will get defaults from the ssh
#   parent class.
#
# === Examples
#
#  class { ssh::client
#    options => {
#      'ForwardX11Trusted' => 'no'
#    }
#  }
#
# === Authors
#
# Simon Piette <piette.simon@gmail.com>
#
# === Copyright
#
# Copyright 2013 Simon Piette
#
class ssh::client (
  $options = $ssh::mergedclientoptions,
  ) {
  include ssh::params
  validate_hash($options)

  Package[$ssh::params::clientpkgname]->
  File[$ssh::params::clientconffile]

  package { $ssh::params::clientpkgname:
    ensure => present,
  }

  file { $ssh::params::clientconffile:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('ssh/ssh_config.erb')
  }
}
