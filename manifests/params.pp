# == Class ssh::params
# This class is meant to be called from ssh
# It set variable according to platform
class ssh::params {
  $pkgname = 'ssh'
  $conffile = 'ssh/etc/ssh.conf'
  $service = $::osfamily ? {
    'Debian' => 'ssh',
    'RedHat' => 'ssh',
    default  => fail('unsupported platform')
  }
}
