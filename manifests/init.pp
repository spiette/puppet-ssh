# == Class: ssh
#
# This class will configure ssh server and client
#
# === Parameters
#
# Parameters provided by distributions have their own parameters. Other
# parameters can be set in the $options associative array.
#
# [ *options*]
#   This hash contains all sshd_config options. The following options are set
#   by default:
#   - PasswordAuthentication yes
#   - ChallengeResponseAuthentication no
#   - GSSAPIAuthentication yes
#   - GSSAPICleanupCredentials yes
#   - X11Forwarding yes
#
# === Examples
#
#  class { ssh:
#    client       => absent,
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
class ssh (
  $options = {}
  ) {
  $defaultoptions = {
    'PasswordAuthentication'          => 'yes',
    'ChallengeResponseAuthentication' => 'no',
    'GSSAPIAuthentication'            => 'yes',
    'GSSAPICleanupCredentials'        => 'yes',
    'X11Forwarding'                   => 'yes',
  }
  $alloptions = merge($defaultoptions, $options)

  Class["${module_name}::install"]->
  Class["${module_name}::config"]~>
  Class["${module_name}::service"]
  include ssh::install
  include ssh::config
  include ssh::service
}
