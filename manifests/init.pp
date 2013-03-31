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
#    options => {
#      'PasswordAuthentication' => 'no',
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
class ssh (
  $client = true,
  $clientoptions = {},
  $serveroptions = {},
  ) {
  $defaultserveroptions = {
    'Subsystem'                       => 'sftp    internal-sftp',
    'PasswordAuthentication'          => 'yes',
    'ChallengeResponseAuthentication' => 'no',
    'GSSAPIAuthentication'            => 'yes',
    'GSSAPICleanupCredentials'        => 'yes',
    'X11Forwarding'                   => 'yes',
  }
  $defaultclientoptions = {
    'ForwardX11Trusted'    => 'yes',
    'GSSAPIAuthentication' => 'yes',
  }
  $mergedserveroptions = merge($defaultserveroptions, $serveroptions)
  $mergedclientoptions = merge($defaultclientoptions, $clientoptions)

  anchor { 'ssh::begin': }->
  class { 'ssh::install': }->
  class { 'ssh::config': }~>
  class { 'ssh::service': }~>
  anchor { 'ssh::end': }

  if $client {
    include ssh::client
  } elsif $::osfamily == 'RedHat' {
    warn('No scp will be available to this host.')
  }
}
