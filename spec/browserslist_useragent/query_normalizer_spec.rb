# frozen_string_literal: true

RSpec.describe BrowserslistUseragent::QueryNormalizer do
  describe '#call' do
    let(:subject) { described_class.new(query).call }

    describe 'browser' do
      context 'when browser is ff' do
        let(:query) { 'ff > 54' }

        it { expect(subject).to include(family: 'Firefox') }
      end

      context 'when browser is and_chr' do
        let(:query) { 'and_chr 64' }

        it { expect(subject).to include(family: 'Chrome') }
      end

      context 'when browser is bb' do
        let(:query) { 'bb > 10' }

        it { expect(subject).to include(family: 'BlackBerry') }
      end

      context 'when browser is ChromeAndroid' do
        let(:query) { 'ChromeAndroid = 1.2.3' }

        it { expect(subject).to include(family: 'Chrome') }
      end

      context 'when browser is FirefoxAndroid' do
        let(:query) { 'FirefoxAndroid > 55' }

        it { expect(subject).to include(family: 'Firefox') }
      end

      context 'when browser is ff' do
        let(:query) { 'ff > 88' }

        it { expect(subject).to include(family: 'Firefox') }
      end

      context 'when browser is ie' do
        let(:query) { 'ie = 10.2' }

        it { expect(subject).to include(family: 'Explorer') }
      end

      context 'when browser is ie_mob' do
        let(:query) { 'ie_mob 1.2' }

        it { expect(subject).to include(family: 'ExplorerMobile') }
      end

      context 'when browser is and_ff' do
        let(:query) { 'and_ff 12' }

        it { expect(subject).to include(family: 'Firefox') }
      end

      context 'when browser is ios_saf' do
        let(:query) { 'ios_saf 3' }

        it { expect(subject).to include(family: 'iOS') }
      end

      context 'when browser is op_mini' do
        let(:query) { 'op_mini = 23' }

        it { expect(subject).to include(family: 'OperaMini') }
      end

      context 'when browser is op_mob' do
        let(:query) { 'op_mob 12-21' }

        it { expect(subject).to include(family: 'OperaMobile') }
      end

      context 'when browser is  and_qq' do
        let(:query) { 'and_qq 1' }

        it { expect(subject).to include(family: 'QQAndroid') }
      end

      context 'when browser is and_uc' do
        let(:query) { 'and_uc 3.4-5.3' }

        it { expect(subject).to include(family: 'UCAndroid') }
      end

      context 'when browser is Chrome' do
        let(:query) { 'Chrome > 5.5' }

        it { expect(subject).to include(family: 'Chrome') }
      end
    end

    describe 'version' do
      context 'when has no version specified' do
        let(:query) { 'ff' }

        it { expect(subject).to include(version: nil) }
      end

      context 'when version has dash' do
        let(:query) { 'Chrome 55-65' }

        it { expect(subject).to eq(family: 'Chrome', version: '55-65') }
      end
    end
  end
end
