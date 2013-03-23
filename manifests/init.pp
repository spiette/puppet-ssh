# == Class: ssh
#
# Full description of class ssh here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Examples
#
#  class { ssh:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class ssh () {
  Class["${module_name}::install"]->
  Class["${module_name}::config"]~>
  Class["${module_name}::service"]
  include ssh::install
  include ssh::config
  include ssh::service
}
