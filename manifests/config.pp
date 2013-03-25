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
  include concat::setup

  validate_hash($options)
  $useprivilegeseparation = $ssh::params::useprivilegeseparation

  concat { $ssh::params::conffile:
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
  }

  concat::fragment { $ssh::params::conffile:
    target  => $ssh::params::conffile,
    content => template('ssh/sshd_config.erb'),
    order   => '10',
  }
}
