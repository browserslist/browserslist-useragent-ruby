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
        agent_version.major,
        agent_version.minor,
        agent_version.patch
      ].map { |x| x.nil? ? 0 : x.to_i.to_s }.join('.')
    end
  end
end
