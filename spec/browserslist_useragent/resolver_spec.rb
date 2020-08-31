# frozen_string_literal: true

RSpec.describe BrowserslistUseragent::Resolver do
  describe '#call' do
    def resolve_user_agent(user_agent)
      described_class.new(user_agent).call
    end

    it 'resolves all browsers in iOS to safari with correct platform version' do
      # chome on iOS
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_0 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) CriOS/60.0.0.0 Mobile/14E5239e Safari/602.1'
        )
      ).to eq(family: 'iOS', version: '10.3.0')

      # firefox on iOS
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) FxiOS/1.0 Mobile/12F69 Safari/600.1.4'
        )
      ).to eq(family: 'iOS', version: '10.3.0')

      # safari mobile on is
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_0 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.3.0 Mobile/14A403 Mobile/603.3.8'
        )
      ).to eq(family: 'iOS', version: '10.3.0')

      # safari on is
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 8_3_0 like Mac OS X) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.3.0 Mobile/14A403 Safari/600.7.12'
        )
      ).to eq(family: 'iOS', version: '8.3.0')
    end

    it 'desktop safari on OS X' do
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1.0 Safari/603.1.30'
        )
      ).to eq(family: 'Safari', version: '10.1.0')
    end

    it 'resolves IE/Edge properly' do
      # explorer
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Windows NT 6.3; Trident/7.0.0; rv:11.0.0) like Gecko'
        )
      ).to eq(family: 'Explorer', version: '11.0.0')

      # explorer on windows phone
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (compatible; MSIE 10.0.0; Windows Phone OS 8.0.0; Trident/6.0.0; IEMobile/10.0.0; Lumia 630'
        )
      ).to eq(family: 'ExplorerMobile', version: '10.0.0')

      # edge
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Windows NT 6.4;) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.0.0 Safari/537.36 Edge/14.1.0.10122'
        )
      ).to eq(family: 'Edge', version: '14.1.0')
    end

    it 'resolves chrome/android properly' do
      # chrome
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Windows NT 6.4) AppleWebKit/537.36.0 (KHTML, like Gecko) Chrome/41.0.228.90 Safari/537.36.0'
        )
      ).to eq(family: 'Chrome', version: '41.0.228')

      # headless
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/60.0.3112.50 Safari/537.36'
        )
      ).to eq(family: 'Chrome', version: '60.0.3112')

      # android
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Linux; U; Android 2.3.3; Pixel Build/Unknown;) AppleWebKit/533.1.0 (KHTML, like Gecko) Version/4.0 Safari/533.1.0'
        )
      ).to eq(family: 'Android', version: '2.3.3')

      # chome mobile
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Linux; Android 4.4.1; Pixel Build/Unknown;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/44.0.0.0 Mobile Safari/537.36'
        )
      ).to eq(family: 'Chrome', version: '44.0.0')

      # chome mobile
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Linux; Android 6.0.0; Pixel Build/Unknown; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/60.0.0.0 Mobile Safari/537.36'
        )
      ).to eq(family: 'Chrome', version: '60.0.0')
    end

    it 'resolves firefox properly' do
      # firefox
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Windows NT 6.4; rv:41.0.0) Gecko/20100101 Firefox/41.0.0'
        )
      ).to eq(family: 'Firefox', version: '41.0.0')

      # firefox mobile
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Android 7.0.0; Build/Unknown; Mobile; rv:44.0.0) Gecko/44.0.0 Firefox/44.0.0'
        )
      ).to eq(family: 'Firefox', version: '44.0.0')
    end

    it 'resolves opera mobile properly' do
      expect(
        resolve_user_agent(
          'Mozilla/5.0 (Linux; Android 10; LYA-L09) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Mobile Safari/537.36 OPR/59.1.2926.54067'
        )
      ).to eq(family: 'OperaMobile', version: '59.1.2926')
    end
  end
end
