# == Class ssh::config
# This class is meant to be called from ssh
# it bakes the configuration file
# === Parameters
#
# [*options*]
#   A hash of extra options to set in the configuration
#
# === Example
#
#  class { ssh:
#    options => {
#      'key1' => 'value1',
#      'key2' => 'value2',
#    }
#  }
class ssh::config(
    $servers=$ssh::servers,
    $options=$ssh::options,
    ) {
  include ssh::params
  file { $ssh::params::conffile:
    ensure  => present,
    mode    => '0440',
    content => template('ssh/ssh.conf.erb')
  }
}

