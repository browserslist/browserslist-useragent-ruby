require 'browserslist/useragent/version'
require 'semantic'
require 'user_agent_parser'

module Browserslist
  # Base module to match user agent and provied browserlists
  module Useragent
    NoVersionError = Class.new(StandardError)

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
    class << self
      def match?(browsers:, useragent:); end
    end

    class AgentVersionBuilder
      attr_reader :agent_version

      def initialize(agent_version)
        @agent_version = agent_version
      end

      def call
        segments = [
          agent_version.major,
          agent_version.minor || 0,
          agent_version.patch || 0
        ]
        segments.push(agent_version.patch_minor) unless agent_version.patch_minor.nil?
        segments.join('.')
      end
    end

    class UserAgentResover
      attr_reader :user_agent_string

      def initialize(user_agent_string)
        @user_agent_string = user_agent_string
      end

      def call
        agent = UserAgentParser.parse(user_agent_string)
        raise NoVersionError, 'Version' if agent.version.nil?

        family = agent.family
        version = AgentVersionBuilder.new(agent.version).call

        # Case A: For Safari, Chrome and others browsers
        # that report as Safari after stripping tags
        family = 'iOS' if agent.family.include?('Safari')

        # Case B: The browser on iOS didn't report as safari,
        # so we use the iOS version as a proxy to the browser
        # version. This is based on the assumption that the
        # underlying Safari Engine used will be *atleast* equal
        # to the iOS version it's running on.
        if agent.os.family == 'iOS'
          return UserAgent.new(
            family: 'iOS',
            version: AgentVersionBuilder.new(agent.os.version).call
          )
        end

        # Case C: The caniuse database does not contain
        # historical browser versions for so called `minor`
        # browsers like Chrome for Android, Firefox for Android etc
        # In this case, we proxy to the desktop version
        # @see https://github.com/Fyrd/caniuse/issues/3518
        family = 'Chrome' if agent.family.include?('Chrome Mobile')

        family = 'Firefox' if agent.family == 'Firefox Mobile'
        family = 'Explorer' if agent.family == 'IE'
        family = 'ExplorerMobile' if agent.family == 'IE Mobile'

        UserAgent.new(family: family, version: version)
      end
    end

    class UserAgent
      attr_reader :family, :version
      def initialize(family:, version:)
        @family = family
        @version = version
      end
    end

    class AgentVersionMatcher
      attr_reader :user_agent
      def initalize(user_agent, options)
        @user_agent = user_agent
        @options = options
      end

      def call(browser); end

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
