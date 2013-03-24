class { 'ssh::client':
  options => {
    'ForwardX11Trusted'    => 'no',
    'GSSAPIAuthentication' => 'no',
  }
}


