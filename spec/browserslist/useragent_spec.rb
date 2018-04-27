RSpec.describe Browserslist::Useragent do
  it 'has a version number' do
    expect(Browserslist::Useragent::VERSION).not_to be nil
  end

  describe 'match' do
    let(:browserlist) do
      ['and_chr 64',
       'and_ff 57',
       'and_qq 1.2',
       'and_uc 11.8',
       'android 62',
       'android 4.4.3-4.4.4',
       'baidu 7.12',
       'bb 10',
       'bb 7',
       'chrome 65',
       'chrome 64',
       'edge 16',
       'edge 15',
       'firefox 59',
       'firefox 58',
       'ie 10',
       'ie_mob 10',
       'ios_saf 11.3',
       'ios_saf 11.0-11.2',
       'op_mob 37',
       'opera 50',
       'opera 49',
       'safari 11.1',
       'safari 11',
       'samsung 6.2',
       'samsung 5']
    end

    let(:matchings) do
      {
        # chrome on android
        'Mozilla/5.0 (Linux; Android 7.0.0; Pixel Build/Unknown;) AppleWebKit/537.36.0 (KHTML, like Gecko) Chrome/40.0.1.0 Mobile Safari/537.36.0' => false,
        'Mozilla/5.0 (Linux; Android 7.0.0; Pixel Build/Unknown;) AppleWebKit/537.36.0 (KHTML, like Gecko) Chrome/64.0.1.0 Mobile Safari/537.36.0' => true,
        # firefox mobile
        'Mozilla/5.0 (Android; Build/Unknown; Mobile; rv:40.0.1) Gecko/40.0.1 Firefox/40.0.1' => false,
        'Mozilla/5.0 (Android; Build/Unknown; Mobile; rv:40.0.1) Gecko/40.0.1 Firefox/56.9.1' => false,
        'Mozilla/5.0 (Android; Build/Unknown; Mobile; rv:40.0.1) Gecko/40.0.1 Firefox/57.0.0' => true,
        'Mozilla/5.0 (Android; Build/Unknown; Mobile; rv:40.0.1) Gecko/40.0.1 Firefox/57.0.1' => true,
        'Mozilla/5.0 (Android; Build/Unknown; Mobile; rv:40.0.1) Gecko/40.0.1 Firefox/57.7.1' => true,

        # qq on android
       'Mozilla/5.0 (Linux; U; Android 4.4.2; zh-cn; GT-I9500 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 MQQBrowser/1.0 QQ-URL-Manager Mobile Safari/537.36' => false,
       'Mozilla/5.0 (Linux; U; Android 4.4.2; zh-cn; GT-I9500 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 MQQBrowser/1.2 QQ-URL-Manager Mobile Safari/537.36' => true,

        # UC Browser
       'Mozilla/5.0 (Linux; U; Android 6.0.1; zh-CN; F5121 Build/34.0.A.1.247) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/40.0.2214.89 UCBrowser/11.5.1.944 Mobile Safari/537.36' => false,
       'Mozilla/5.0 (Linux; U; Android 6.0.1; zh-CN; F5121 Build/34.0.A.1.247) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/40.0.2214.89 UCBrowser/11.8.1.944 Mobile Safari/537.36' => true,

      }
    end

    it do
      matchings.each do |user_agent, satisfied|
        expect(described_class.match?(
          user_agent: user_agent,
          browsers: browserlist
        )).to eq satisfied
      end
    end
  end
end
