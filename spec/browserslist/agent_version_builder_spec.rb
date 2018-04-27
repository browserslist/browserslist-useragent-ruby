require 'spec_helper'

RSpec.describe Browserslist::Useragent::AgentVersionBuilder do
  describe '#call' do
    let(:matchings) do
      {
        '1.0' => '1.0.0',
        '1' => '1.0.0',
        '1.2.3' => '1.2.3',
        '1.2.3.4' => '1.2.3.4'
      }
    end

    it 'converts version to correct server' do
      matchings.each do |v, semver|
        vv = described_class.new(UserAgentParser::Version.new(v)).call
        expect(vv).to eq semver
      end
    end
  end
end
