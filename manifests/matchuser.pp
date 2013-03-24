# == ssh::matchuser
#
#   ssh::matchuser add a Match User block to set options specific to a user.
#
# == Parameters
#
# [*user*]
#   User affected by the following options. Defaults to define's name.
#
# [*options*]
#   A hash of options to set for the user. Defaults to {}. Will fail if empty.
#
define ssh::matchuser ($options) {
    include ssh
}
