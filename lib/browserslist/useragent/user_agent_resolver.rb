module Browserslist
  module Useragent
    class UserAgentResover
      attr_reader :user_agent_string

      def initialize(user_agent_string)
        @user_agent_string = user_agent_string
      end

      def call
        agent = UserAgentParser.parse(user_agent_string)
        raise NoVersionError, 'Version' if agent.version.nil?

        family = agent.family
        version = VersionBuilder.new(agent.version.to_s).call

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
            version: VersionBuilder.new(agent.os.version.to_s).call
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
  end
end
