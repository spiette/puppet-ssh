# == Class ssh::params
# This class is meant to be called from ssh
# It set variable according to osfamily
class ssh::params {
  $pkgname = 'openssh-server'
  $conffile = '/etc/ssh/sshd_config'
  $clientconffile = '/etc/ssh/ssh_config'
  case $::osfamily {
    'Debian': {
      $service = 'ssh'
      $clientpkgname = 'openssh-client'
    }
    'RedHat': {
      $service = 'sshd'
      $clientpkgname = 'openssh-clients'
    }
    default: {
      fail('unsupported platform')
    }
  }
  # useprivilegeseparation is only available on openssh 5.8 and later
  case $::operatingsystem {
    'Redhat', 'CentOS', 'Scientific', 'Debian': {
      if $::lsbmajrelease < 7 {
        $useprivilegeseparation = 'yes'
      } else {
        $useprivilegeseparation = 'sandbox'
      }

    }
    'Ubuntu': {
      if $::operatingsystemmajrelease < 12 {
        $useprivilegeseparation = 'yes'
      } else {
        $useprivilegeseparation = 'sandbox'
      }
    }
    'XenServer': {
      $useprivilegeseparation = 'yes'
    }
    default: {
      $useprivilegeseparation = 'sandbox'
    }
  }
}
