require 'spec_helper'

config = '/etc/ssh/ssh_config'
package = {
  'RedHat' => 'openssh-clients',
  'Debian' => 'openssh-client',
}

describe 'ssh::client' do
  let(:title) { 'ssh::client' }

  ['Debian', 'RedHat'].each do |osfamily|
    context "class with some parameters on #{osfamily}" do 
      let(:params) {
        { :options => {
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
      it { should create_package(package[osfamily]) }
      it { should create_file(config) }
      it {
        should create_file(config)\
        .with_content(/\bGSSAPIAuthentication no$/)\
        .with_content(/\bForwardX11Trusted no$/)\
      }
    end
  end
end
