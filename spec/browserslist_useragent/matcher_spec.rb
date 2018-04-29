# frozen_string_literal: true

RSpec.describe BrowserslistUseragent::Matcher do
  let(:matcher) { described_class.new(queries, 'user agent') }
  let(:queries) do
    [
      'firefox 59', 'firefox 58', 'chrome 64', 'chrome 65',
      'ie 10', 'and_uc 11.8', 'android 4.4.3-4.4.4',
      'ios_saf 11.3', 'ios_saf 11.0-11.2'
    ]
  end

  before do
    allow(matcher).to receive(:resolver).and_return(
      double(call: user_agent)
    )
  end

  describe '#browser?' do
    context 'when family is iOS' do
      let(:user_agent) { { family: 'iOS' } }

      it { expect(matcher).to be_browser }
    end

    context 'when family is Explorer' do
      let(:user_agent) { { family: 'Explorer' } }

      it { expect(matcher).to be_browser }
    end

    context 'when family is Chrome' do
      let(:user_agent) { { family: 'Chrome' } }

      it { expect(matcher).to be_browser }
    end

    context 'when family is BlackBerry' do
      let(:user_agent) { { family: 'BlackBerry' } }

      it { expect(matcher).not_to be_browser }
    end
  end

  describe '#version?' do
    context 'when rule has single version with major only' do
      context 'when version fully matches with version in rule' do
        let(:user_agent) { { family: 'Chrome', version: '65.0.0' } }

        it { expect(matcher).to be_version }
      end

      context 'when version patch is greater' do
        let(:user_agent) { { family: 'Chrome', version: '65.0.1' } }

        it { expect(matcher).to be_version }
      end

      context 'when version minor is greater' do
        let(:user_agent) { { family: 'Chrome', version: '65.1.0' } }

        it { expect(matcher).to be_version }
      end

      context 'when major version is greater' do
        let(:user_agent) { { family: 'Chrome', version: '66.0.0' } }

        it { expect(matcher).not_to be_version }
      end
    end

    context 'when rule has signle version with minor' do
      context 'when version fully matches with version in rule' do
        let(:user_agent) { { family: 'iOS', version: '11.3.0' } }

        it { expect(matcher).to be_version }
      end

      context 'when version patch is greater' do
        let(:user_agent) { { family: 'iOS', version: '11.3.1' } }

        it { expect(matcher).to be_version }
      end

      context 'when version minor is greater' do
        let(:user_agent) { { family: 'iOS', version: '11.4.0' } }

        it { expect(matcher).not_to be_version }
      end

      context 'when major version is greater' do
        let(:user_agent) { { family: 'iOS', version: '12.4.0' } }

        it { expect(matcher).not_to be_version }
      end
    end

    context 'when rule has signle version with patch' do
      context 'when version fully matches with version in rule' do
        let(:user_agent) { { family: 'android', version: '4.4.3' } }

        it { expect(matcher).to be_version }
      end

      context 'when version patch is greater' do
        let(:user_agent) { { family: 'android', version: '4.4.4' } }

        it { expect(matcher).to be_version }
      end

      context 'when version patch is greater' do
        let(:user_agent) { { family: 'android', version: '4.4.5' } }

        it { expect(matcher).not_to be_version }
      end

      context 'when version minor is greater' do
        let(:user_agent) { { family: 'android', version: '4.5.0' } }

        it { expect(matcher).not_to be_version }
      end

      context 'when major version is greater' do
        let(:user_agent) { { family: 'android', version: '5.0.0' } }

        it { expect(matcher).not_to be_version }
      end
    end
  end
end
