require 'spec_helper'

serverconfig = '/etc/ssh/sshd_config'
clientconfig = '/etc/ssh/ssh_config'
service = {
  'RedHat' => 'sshd',
  'Debian' => 'ssh',
}
serverpackage = 'openssh-server'
clientpackage = {
  'RedHat' => 'openssh-clients',
  'Debian' => 'openssh-client',
}

describe 'ssh' do
  let(:title) { 'ssh' }

  ['Debian', 'RedHat'].each do |osfamily|
    context "class without any parameters on #{osfamily}" do 
      let(:params) {{ }}
      let(:facts) { { :osfamily => osfamily } }


      it { should create_class('ssh') }
      it { should create_package(serverpackage) }
      it { should create_file(serverconfig) }
      it {
        should create_file(serverconfig)\
        .with_content(/^PasswordAuthentication yes$/)\
        .with_content(/^UsePrivilegeSeparation sandbox/)\
        .with_content(/^X11Forwarding yes$/)\
        .with_content(/^GSSAPIAuthentication yes$/)\
        .with_content(/^GSSAPICleanupCredentials yes$/)\
      }
      it { should create_service(service[osfamily]) }
    end
    context "class with some parameters on #{osfamily}" do 
      let(:params) {
        { :serveroptions => {
            'PasswordAuthentication' => 'no',
            'PermitRootLogin'        => 'without-password',
            'UseDNS'                 => 'no',
          }
        }
      }
      let(:facts) { { :osfamily => osfamily } }

      it { should create_class('ssh') }
      it { should create_package(serverpackage) }
      it { should create_file(serverconfig) }
      it {
        should create_file(serverconfig)\
        .with_content(/^PasswordAuthentication no$/)\
        .with_content(/^UsePrivilegeSeparation sandbox/)\
        .with_content(/^X11Forwarding yes$/)\
        .with_content(/^GSSAPIAuthentication yes$/)\
        .with_content(/^GSSAPICleanupCredentials yes$/)\
        .with_content(/^PermitRootLogin without-password$/)\
        .with_content(/^UseDNS no$/)\
      }
      it { should create_service(service[osfamily]) }
    end
    # client tests
    context "client class without parameters on #{osfamily}" do 
      let(:facts) { { :osfamily => osfamily } }

      it { should create_class('ssh::client') }
      it { should create_package(clientpackage[osfamily]) }
      it { should create_file(clientconfig) }
      it {
        should create_file(clientconfig)\
        .with_content(/\bGSSAPIAuthentication yes$/)\
        .with_content(/\bForwardX11Trusted yes$/)\
      }
    end
    context "client class with some parameters on #{osfamily}" do 
      let(:params) {
        { :clientoptions => {
            'GSSAPIAuthentication' => 'no',
            'ForwardX11Trusted'    => 'no',
          }
        }
      }
      let(:facts) { { :osfamily => osfamily } }

      it { should create_class('ssh::client') }
      it { should create_package(clientpackage[osfamily]) }
      it { should create_file(clientconfig) }
      it {
        should create_file(clientconfig)\
        .with_content(/\bGSSAPIAuthentication no$/)\
        .with_content(/\bForwardX11Trusted no$/)\
      }
    end
  end
end
