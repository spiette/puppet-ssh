require 'spec_helper'

describe 'ssh::install' do
  let(:title) { 'ssh::install' }

      let(:facts) { {
        :concat_basedir => '/dne',
        :osfamily       => osfamily
      } }
  let(:facts) { {
    :concat_basedir            => '/dne',
    :osfamily                  => 'Debian',
    :operatingsystem           => 'Debian',
    :operatingsystemrelease    => 7.1,
    :operatingsystemmajrelease => '7',
  } }

  context "no autoupdate" do
    it { should create_package('openssh-server').with_ensure('present') }
  end
  context "autoupdate" do
    let(:params) { { :autoupdate => true } }
    it { should create_package('openssh-server').with_ensure('latest') }
  end
  context "autoupdate wrong argument" do
    let(:params) { { :autoupdate => 'true' } }
    it { expect {
      create_package('openssh-server').to\
        raise_error(Puppet::Error, /autoupdate should be true or false/)
    } }
  end
end
