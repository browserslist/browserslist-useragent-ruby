# frozen_string_literal: true

require 'semantic'

module BrowserslistUseragent
  # Checks matching of browserslist queies array to the user agent string
  class Matcher
    attr_reader :queries, :user_agent

    def initialize(queries, user_agent)
      @user_agent = user_agent
      @queries = queries.each_with_object([]) do |query, arr|
        arr.push(::BrowserslistUseragent::QueryNormalizer.new(query).call)
      end
    end

    def match?
      agent = resolver.call
      queries.any? do |query|
        match_user_agent_family?(agent[:family], query[:family]) &&
          match_user_agent_version?(agent[:version], query[:version])
      end
    end

    def browser_match?
      agent = resolver.call
      queries.any? do |query|
        match_user_agent_family?(agent[:family], query[:family])
      end
    end

    private

    def resolver
      @resolver ||= Resolver.new(user_agent)
    end

    def match_user_agent_version?(user_agent_version, query_browser_version)
      semantic = Semantic::Version.new(user_agent_version)

      if query_browser_version.include?('-')
        low_version, hight_version = query_browser_version.split('-', 2)
        semantic.satisfies?(">= #{low_version}") &&
          semantic.satisfies?("<= #{hight_version}")
      else
        semantic.satisfies?(query_browser_version)
      end
    end

    def match_user_agent_family?(user_agent_family, query_browser_family)
      user_agent_family.casecmp(query_browser_family).zero?
    end
  end
end
