require 'user_agent_parser'

module Browserslist
  module Useragent
    # Normalizes user agent version to semantically valid state
    class VersionNormalizer
      attr_reader :version

      def initialize(version)
        @version = version
      end

      def call
        agent_version = ::UserAgentParser::Version.new(version)
        [
          agent_version.major,
          agent_version.minor || 0,
          agent_version.patch || 0
        ].join('.')
      end
    end
  end
end
