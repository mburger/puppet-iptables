require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'iptables::rule' do
  let(:title) { 'iptable1' }
  let(:node) { 'iptable.example42.com' }
  let(:facts) { { :operatingsystem => 'ubuntu' } }

  describe 'Test iptables::rule with ip as string' do
    let(:params) {
      { 'source'        => '1.2.3.4',
        'source_v6'     => '',
        'destination'   => '2.3.4.5',
        'destination_v6'=> '',
        'protocol'      => 'tcp',
        'port'          => '1234',
      }
    }
    it { should contain_concat__fragment( "iptables_rule_iptable1" ) }
  end

  describe 'Test iptables::rule for v4 only' do
    let(:params) {
      { 'source'        => ['1.2.3.4'],
        'source_v6'     => '',
        'destination'   => ['2.3.4.5'],
        'destination_v6'=> '',
        'protocol'      => 'tcp',
        'port'          => '1234',
      }
    }
    it { should contain_concat__fragment( "iptables_rule_iptable1" ) }
    it { should_not contain_concat__fragment( "iptables_rule_v6_iptable1" ) }
  end
  
  describe 'Test iptables::rule for v4 and v6' do
    let(:params) {
      { 'source'        => ['1.2.3.4'],
        'source_v6'     => ['fe80::a00:27ff:fea4:b70e'],
        'destination'   => ['2.3.4.5'],
        'destination_v6'=> ['fe80::a00:27ff:fea4:b70e'],
        'protocol'      => 'tcp',
        'port'          => '1234',
        'enable_v6'     => true,
      }
    }
    it { should contain_concat__fragment( "iptables_rule_iptable1" ) }
    it { should contain_concat__fragment( "iptables_rule_v6_iptable1" ).with(
      'target'  => '/etc/iptables/rules.v6',
    ) }
  end
  
  describe 'Test iptables::rule with port and protocol only' do
    let(:params) {
      { 'protocol'      => 'tcp',
        'port'          => '1234',
        'enable_v6'     => true,
      }
    }
    it { should contain_concat__fragment( "iptables_rule_iptable1" ).with(
      'target'  => '/etc/iptables/rules.v4',
      'content' => '-A INPUT -p tcp --dport 1234 -s 0/0 -d 0/0 -j ACCEPT\\n',
    ) }
    it { should contain_concat__fragment( "iptables_rule_v6_iptable1" ).with(
      'target'  => '/etc/iptables/rules.v6',
      'content' => '-A INPUT -p tcp --dport 1234 -s 0/0 -d 0/0 -j ACCEPT\\n',
    ) }
  end
end
