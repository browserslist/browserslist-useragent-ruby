require 'browserslist/useragent/version'
require 'semantic'
require 'user_agent_parser'

require 'browserslist/useragent/user_agent'
require 'browserslist/useragent/version_builder'
require 'browserslist/useragent/user_agent_matcher'
require 'browserslist/useragent/user_agent_resolver'

module Browserslist
  # Base module to match user agent and provied browserlists
  module Useragent
    NoVersionError = Class.new(StandardError)

   class << self
      def match?(browsers:, useragent:)
        browsers.each do |browser|
          return true if AgentVersionMatcher.new(user_agent).call
        end
        false
      end
    end
  end
end
