require 'spec_helper'

describe 'ssh' do
  let(:title) { 'ssh' }

  ['Debian', 'RedHat'].each do |osfamily|
    describe "ssh class without any parameters on #{osfamily}" do 
      let(:params) {{ }}
      let(:facts) { { :osfamily => osfamily } }

      it { should create_class('ssh') }
      it { should create_package('ssh') }
      it { should create_file('/etc/ssh.conf') }
      it {
        should create_file('/etc/ssh.conf')\
        .with_content(/^server pool.ssh.org$/)
      }
      if osfamily == 'RedHat' 
        it { should create_service('sshd') }
      else
        it { should create_service('ssh') }
      end
    end
  end
end
