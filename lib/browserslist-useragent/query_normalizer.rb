module Browserslist
  module Useragent
    class QueryNormalizer
      NORMALIZED_NAMES = {
        bb: 'BlackBerry',
        and_chr: 'Chrome',
        ChromeAndroid: 'Chrome',
        FirefoxAndroid: 'Firefox',
        ff: 'Firefox',
        ie: 'Explorer',
        ie_mob: 'ExplorerMobile',
        and_ff: 'Firefox',
        ios_saf: 'iOS',
        op_mini: 'OperaMini',
        op_mob: 'OperaMobile',
        and_qq: 'QQAndroid',
        and_uc: 'UCAndroid'
      }.freeze

      attr_reader :query

      def initialize(query)
        @query = query
      end

      def call
        browser_name, browser_version = query.split(' ', 2)
        normalized_name = NORMALIZED_NAMES[browser_name.to_sym] || browser_name

        { family: normalized_name, version: browser_version }
      end
    end
  end
end
