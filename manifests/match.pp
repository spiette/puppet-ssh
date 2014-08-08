# == ssh::match
#
#   ssh::match add a Match type block to set options specific to a matching
#   criteria pattern. See sshd_config(5).
#
# == Parameters
#
# [*type*]
#   Depreciated. For backwards-compatibility, this parameter defines the object type in a single match condition.
#
# [*pattern*]
#   Depreciated. When matching on a single condition, the pattern to be matched against. Defaults to $name
#
# [*conditions*]
#   A hash of type/pattern pairs to use in matching on multiple conditions. Has no effect, if $type is defined.
# 
# [*options*]
#   A hash of options to set for the user. Defaults to {}. Will fail if empty.
#
define ssh::match (
  $type       = undef,
  $pattern    = $name,
  $conditions = undef,
  $options,
) {
  if $type != undef and !($type in [
    'user',
    'group',
    'host',
    'localaddress',
    'localport',
    'address',
  ]) {
    fail("Unknown type match: ${type}")
  } elsif $type == undef and $conditions == undef {
    fail("Either \$type or \$conditions must be specified.") 
  } elsif $conditions != undef and !(is_hash($conditions)) {
    fail("\$conditions must be an array")
  } else {
    include ssh
    concat::fragment { "ssh_match_${name}":
      target  => $ssh::params::conffile,
      order   => 20,
      content => template('ssh/sshd_config_match.erb')
    }
  }
}
