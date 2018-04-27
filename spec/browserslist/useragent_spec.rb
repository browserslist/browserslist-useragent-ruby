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
  end
end
