# == Class ssh::config
# This class is meant to be called from ssh
# it bakes the configuration file
# === Parameters
#
# [*options*]
#   A hash of extra options to set in the configuration
#
class ssh::config (
    $options=$ssh::mergedserveroptions,
    ) {
  include ssh::params
  validate_hash($options)

  file { $ssh::params::conffile:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template('ssh/sshd_config.erb')
  }
}
