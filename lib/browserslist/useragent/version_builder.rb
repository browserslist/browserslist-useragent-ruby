module Browserslist
  module Useragent
    class VersionBuilder
      attr_reader :agent_version

      def initialize(agent_version)
        @agent_version = UserAgentParser::Version.new(agent_version)
      end

      def call
        [
          agent_version.major,
          agent_version.minor || 0,
          agent_version.patch || 0
        ].join('.')
      end
    end
  end
end
