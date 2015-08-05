require 'spec_helper'
include PuppetSpecFacts # shown here, but should be included from spec_helper.rb

osfamilies = [ 'RedHat', 'Debian' ]
describe 'ssh' do
  context 'all operating systems' do
    PuppetSpecFacts.puppet_platforms.each do |name, facthash|
      next if ( osfamilies.count(facthash['osfamily']) < 1 )
      describe "ssh class without any parameters on #{name}" do
        let(:params) {{ }}
        let(:facts) { facthash }

        it { should compile.with_all_deps }
      end
    end
  end
end
