
# ssh puppet module
[![Build Status](https://secure.travis-ci.org/spiette/puppet-ssh.png?branch=master)](http://travis-ci.org/spiette/puppet-ssh)

This is the ssh module. It manage client and server configurations. It supports:

- Any global sshd_config and ssh_config options
- Match block defines to confine users, group, etc to a shell, a chroot, or an
  configuration options you can think of.

The following options are set in the default server options parameter

- Subsystem                       => sftp internal-sftp
- PasswordAuthentication          => yes
- ChallengeResponseAuthentication => no
- GSSAPIAuthentication            => yes
- GSSAPICleanupCredentials        => yes
- X11Forwarding                   => yes

The following options are set in the default client options parameter

- ForwardX11Trusted    => yes
- GSSAPIAuthentication => yes

ssh::config have a config_template parameter to change the template file.

# Requirements

- puppetlabs/stdlib >= 3.0.0
- ripienarr/concat >= 0.2.0
- facter >= 1.7.3

# OS
- RedHat and Debian OS family are supported.

# License
Apache License, Version 2.0

# Usage

<pre>
class { 'ssh':
  serveroptions => {
    'PasswordAuthentication' => 'no',
  }
}

ssh::match { 'sftpusers':
  type                => 'group',
  options             => {
    'X11Forwarding'      => 'no',
    'AllowTCPForwarding' => 'no',
    'GatewayPorts'       => 'no',
    'ForceCommand'       => 'internal-sftp',
    'ChrootDirectory'    => '/srv/www/%u',
  },
}
</pre>

# Tests
To run tests, you'll need

* rake
* rspec_puppet
* puppetlabs_spec_helper

Run `rake help` to see all targets, `rake spec` to run tests.

# Contact
Simon Piette <piette.simon@gmail.com>

# Support

Please log tickets and issues at our [github page](https://github.com/spiette/puppet-ssh)
