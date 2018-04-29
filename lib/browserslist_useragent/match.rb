# frozen_string_literal: true

require 'semantic'

module BrowserslistUseragent
  # Checks matching of browserslist queies array to the user agent string
  class Match
    attr_reader :queries, :user_agent

    def initialize(queries, user_agent)
      @user_agent = user_agent
      @queries = queries.each_with_object({}) do |query, hash|
        query = BrowserslistUseragent::QueryNormalizer.new(query).call
        family = query[:family].downcase
        hash[family] ||= []
        hash[family].push(query[:version])
      end
    end

    def version?
      agent = resolver.call
      return false unless browser?

      target_browser = agent[:family].downcase

      queries[target_browser].any? do |version|
        match_user_agent_version?(agent[:version], version)
      end
    end

    def browser?
      agent = resolver.call
      target_browser = agent[:family].downcase
      queries.key?(target_browser)
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
  end
end
