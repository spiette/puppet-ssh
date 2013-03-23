require 'spec_helper'

config = '/etc/ssh/sshd_config'
service = {
  'RedHat' => 'sshd',
  'Debian' => 'ssh',
}
package = 'openssh-server'

describe 'ssh' do
  let(:title) { 'ssh' }

  ['Debian', 'RedHat'].each do |osfamily|
    context "class without any parameters on #{osfamily}" do 
      let(:params) {{ }}
      let(:facts) { { :osfamily => osfamily } }


      it { should create_class('ssh') }
      it { should create_package(package) }
      it { should create_file(config) }
      it {
        should create_file(config)\
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
        { :options => {
            'PasswordAuthentication' => 'no',
            'PermitRootLogin'        => 'without-password',
            'UseDNS'                 => 'no',
          }
        }
      }
      let(:facts) { { :osfamily => osfamily } }

      it { should create_class('ssh') }
      it { should create_package(package) }
      it { should create_file(config) }
      it {
        should create_file(config)\
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
  end
end
