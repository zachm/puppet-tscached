require 'spec_helper'

describe 'tscached', :type => :class do

  context 'no parameters' do
    it { should contain_package('tscached').with_ensure('latest') }
    it { should contain_file('/etc/tscached.yaml').with_content(/host: localhost/) }
    it { should contain_file('/etc/tscached.uwsgi.ini').with_content(/callable = app/) }
    it { should contain_service('tscached').with_ensure('running').with_enable(true) }
    it { should compile }
  end

  context 'with custom redis and kairos hosts' do
    let(:params) { {'redis_host' => 'redis.noname.com', 'kairosdb_host' => 'kairos.noname.com' } }
    it { should contain_file('/etc/tscached.yaml').with_content(/host: redis.noname.com/) }
    it { should contain_file('/etc/tscached.yaml').with_content(/host: kairos.noname.com/) }
    it { should compile }
  end

  context 'with custom process and thread counts' do
    let(:params) { {'num_processes' => 4, 'num_threads' => 8 } }
    it { should contain_file('/etc/tscached.uwsgi.ini').with_content(/threads = 8/) }
    it { should contain_file('/etc/tscached.uwsgi.ini').with_content(/processes = 4/) }
    it { should compile }
  end

end
