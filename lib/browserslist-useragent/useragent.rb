# frozen_string_literal: true

module Browserslist
  # Base module to match user agent and provied browserlists
  module Useragent
    NoVersionError = Class.new(StandardError)
    NoBrowserError = Class.new(StandardError)

    class << self
       def match?(browsers:, user_agent:)
         ua = UserAgentResolver.new(user_agent).call
         matcher = UserAgentMatcher.new(ua)
         browsers.any? { |browser| matcher.call(browser) }
       end
     end
  end
end
