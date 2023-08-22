# frozen_string_literal: true

require 'user_agent_parser'

module BrowserslistUseragent
  # Normalizes user agent version to semantically valid state
  class VersionNormalizer
    attr_reader :version

    def initialize(version)
      @version = version
    end

    def call
      agent_version = ::UserAgentParser::Version.new(version)
      return nil if agent_version.major.nil?

      [
        agent_version.major.to_i,
        agent_version.minor.to_i || 0,
        agent_version.patch.to_i || 0
      ].join('.')
    end
  end
end
