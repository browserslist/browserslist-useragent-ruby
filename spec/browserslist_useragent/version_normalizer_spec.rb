# frozen_string_literal: true

RSpec.describe BrowserslistUseragent::VersionNormalizer do
  describe '#call' do
    let(:subject) { described_class.new(version).call }

    context 'when version has only major part' do
      let(:version) { '1' }

      it { expect(subject).to eq '1.0.0' }
    end

    context 'when version has only major and minor part' do
      let(:version) { '1.0' }

      it { expect(subject).to eq '1.0.0' }
    end

    context 'when version has all parts: major, minor and patch' do
      let(:version) { '1.2.3' }

      it { expect(subject).to eq '1.2.3' }
    end

    context 'when version has extra parts' do
      let(:version) { '1.2.3.4' }

      it { expect(subject).to eq '1.2.3' }
    end
  end
end
