# == Class ssh::params
# This class is meant to be called from ssh
# It set variable according to platform
class ssh::params {
  $pkgname = 'openssh-server'
  $conffile = '/etc/ssh/sshd_config'
  $clientconffile = '/etc/ssh/ssh_config'
  $service = $::osfamily ? {
    'Debian' => 'ssh',
    'RedHat' => 'sshd',
    default  => fail('unsupported platform')
  }
}
