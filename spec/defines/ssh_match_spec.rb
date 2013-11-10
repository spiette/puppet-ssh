require 'spec_helper'

serverconfig = '/etc/ssh/sshd_config'
describe 'ssh::match', :type => :define do

  context "fail if no params" do
    let :title do
      'username'
    end

    let :facts do
      {
        :concat_basedir            => '/dne',
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :operatingsystemrelease    => 7.1,
        :operatingsystemmajrelease => '7',
      }
    end
    let :params do {
      :type => 'foobar'
    }
    end
    it { expect {
      should include_class('ssh') }.to\
        raise_error(Puppet::Error, /Must pass options to/)
    }
  end

  matchblock = {
    'user'         => 'username',
    'group'        => 'groupname',
    'host'         => 'hostname',
    'localaddress' => 'localaddressname',
    'localport'    => 'localportname',
    'address'      => 'addressname',
  }
  matchblock.each do |type, pattern|
    context " #{type}: #{pattern}" do
      let :title do
        pattern
      end

      let :facts do
      {
        :concat_basedir            => '/dne',
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :operatingsystemrelease    => 7.1,
        :operatingsystemmajrelease => '7',
      }
      end
      let :params do
        {
          :type      => type,
          :options   => {
          'X11Forwarding'      => 'no',
          'AllowTcpForwarding' => 'no',
          },
        }
      end

      it { should include_class('ssh') }
      it { should contain_ssh__params }
      it {
        should contain_concat__fragment("ssh_match_#{type}_#{pattern}")\
        .with_content(/    AllowTcpForwarding no$/)\
        .with_content(/    X11Forwarding no$/)\
        .with(
          'order'  => '20',
          'target' => serverconfig
        )
      }
    end
  end
end
