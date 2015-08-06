# == Class ssh::config
# This class is meant to be called from ssh
# it bakes the configuration file
# === Parameters
#
# [*options*]
#   A hash of extra options to set in the configuration
#
# [*config_template*]
#   An optional erb template you can give instead of the provided one.
#
class ssh::config (
  $options=$ssh::mergedserveroptions,
  $config_template = undef,
  ) {
  include ssh::params

  validate_hash($options)
  $useprivilegeseparation = $ssh::params::useprivilegeseparation

  concat { $ssh::params::conffile:
    owner => 'root',
    group => 'root',
    mode  => '0400',
  }

  if $config_template == undef {
    $sshd_config = 'ssh/sshd_config.erb'
  } else {
    $sshd_config = $config_template
  }

  concat::fragment { $ssh::params::conffile:
    target  => $ssh::params::conffile,
    content => template($sshd_config),
    order   => '10',
  }
}
