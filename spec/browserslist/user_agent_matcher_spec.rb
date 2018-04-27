require 'spec_helper'

RSpec.describe Browserslist::Useragent::UserAgentMatcher do
  it 'matches' do
    {
      {family: 'Firefox', version: '40.0.1'} => 'Firefox >= 40',
      {family: 'Firefox', version: '30.0.0'} => 'Firefox >= 10',
      {family: 'Firefox', version: '30.0.0'} => 'ff >= 10',
      {family: 'iOS', version: '11.0.0'} => 'iOS >= 10.3.0'
    }.each do |ua, rule|
      user_agent = Browserslist::Useragent::UserAgent.new(ua)
      matches = described_class.new(user_agent).call(rule)
      expect(matches).to be_truthy
    end
  end
end
