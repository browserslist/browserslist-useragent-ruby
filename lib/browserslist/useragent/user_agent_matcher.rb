module Browserslist
  module Useragent
    class UserAgentMatcher
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
 
      attr_reader :user_agent
      def initialize(user_agent, options = {})
        @user_agent = user_agent
        @options = options
      end

      def call(browser)
        browser_name, version = browser.split(' ', 2)
        normalized_name = NORMALIZED_NAMES[browser_name.to_sym] || browser_name
        return false if normalized_name != user_agent.family

        normalized_version = version.split('-').first
        ua_semantic =Semantic::Version.new(user_agent.version)
        ua_semantic.satisfies?(normalized_version)
      end

      private

      def ignore_patch?
        @options.fetch(:ignore_patch, true)
      end

      def ignore_minor?
        @options.fetch(:ignore_minor, false)
      end
    end
  end
end
