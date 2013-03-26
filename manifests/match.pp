# == ssh::match
#
#   ssh::match add a Match type block to set options specific to a matching
#   criteria pattern. See sshd_config(5).
#
# == Parameters
#
# [*type*]
#   Object type affected by the following options.
#
# [*pattern*]
#   Pattern to be matched against. Defaults to $name
#
# [*options*]
#   A hash of options to set for the user. Defaults to {}. Will fail if empty.
#
define ssh::match ($type, $options, $pattern=$name) {
  include ssh
  if $type in [
    'user',
    'group',
    'host',
    'localaddress',
    'localport',
    'address',
  ] {
    concat::fragment { "ssh_match_${type}_${pattern}":
      target  => $ssh::params::conffile,
      order   => 20,
      content => template('ssh/sshd_config_match.erb')
    }
  } else {
    fail("Unknown type match: ${type}")
  }
}
