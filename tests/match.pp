ssh::match { 'username':
  type    => 'user',
  options => {
  'X11Forwarding'      => 'no',
  'AllowTcpForwarding' => 'no',
  }
}

