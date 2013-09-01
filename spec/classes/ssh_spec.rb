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

# osfamily, operatingsystem, operatingsystemrelease, privilegeseparationvalue
osmatrix = [
  [ 'RedHat', 'RedHat', 4.0 , 'yes' ],
  [ 'RedHat', 'RedHat', 4.3 , 'yes' ],
  [ 'RedHat', 'RedHat', 5.0 , 'yes' ],
  [ 'RedHat', 'RedHat', 5.1 , 'yes' ],
  [ 'RedHat', 'RedHat', 5.9 , 'yes' ],
  [ 'RedHat', 'RedHat', 5.10 , 'yes' ],
  [ 'RedHat', 'RedHat', 6.0 , 'yes' ],
  [ 'RedHat', 'RedHat', 6.4 , 'yes' ],
  [ 'RedHat', 'RedHat', 7.0 , 'sandbox' ],
  [ 'RedHat', 'Fedora', 17 , 'sandbox' ],
  [ 'Debian', 'Debian', 6.0 , 'yes' ],
  [ 'Debian', 'Debian', 7.0 , 'sandbox' ],
  [ 'Debian', 'Ubuntu', 8.04 , 'yes' ],
  [ 'Debian', 'Ubuntu', 10.04 , 'yes' ],
  [ 'Debian', 'Ubuntu', 12.04 , 'sandbox' ],
  [ 'Debian', 'Ubuntu', 14.04 , 'sandbox' ],
]


describe 'ssh' do
  let(:title) { 'ssh' }

  osmatrix.each do | osfamily, os, osrelease, privsep |
    context "UsePrivilegeSeparation: #{os} #{osrelease}" do
      let(:params) {{ }}
      let(:facts) { {
        :concat_basedir            => '/dne',
        :osfamily                  => osfamily,
        :operatingsystem           => os,
        :operatingsystemrelease    => osrelease,
        :operatingsystemmajrelease => osrelease.round,
      } }
      it { should create_file(serverconfig) }
      it {
        should contain_concat__fragment(serverconfig)\
        .with_content(/^UsePrivilegeSeparation #{privsep}/)\
      }
    end
  end
  ['Debian', 'RedHat'].each do |osfamily|
    context "class without any parameters on #{osfamily}" do
      let(:params) {{ }}
      let(:facts) { {
        :concat_basedir => '/dne',
        :osfamily       => osfamily
      } }


      it { should create_class('ssh') }
      it { should create_package(serverpackage) }
      it { should create_file(serverconfig) }
      it {
        should contain_concat__fragment(serverconfig)\
        .with_content(/^PasswordAuthentication yes$/)\
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
      let(:facts) { {
        :concat_basedir => '/dne',
        :osfamily       => osfamily
      } }

      it { should create_class('ssh') }
      it { should create_package(serverpackage) }
      it { should create_file(serverconfig) }
      it {
        should contain_concat__fragment(serverconfig)\
        .with_content(/^PasswordAuthentication no$/)\
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
      let(:facts) { {
        :concat_basedir => '/dne',
        :osfamily       => osfamily
      } }

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
      let(:facts) { {
        :concat_basedir => '/dne',
        :osfamily       => osfamily
      } }

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
