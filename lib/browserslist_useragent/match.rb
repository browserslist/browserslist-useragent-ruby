# frozen_string_literal: true

require 'semantic'

module BrowserslistUseragent
  # Checks matching of browserslist queries array to the user agent string
  class Match
    attr_reader :queries, :user_agent_string

    def initialize(queries, user_agent_string)
      @user_agent_string = user_agent_string
      @queries = queries.each_with_object({}) do |query, hash|
        query = BrowserslistUseragent::QueryNormalizer.new(query).call
        family = query[:family].downcase
        hash[family] ||= []
        hash[family].push(query[:version])
      end
    end

    def version?(allow_higher: false)
      return false unless browser?

      user_agent_version = user_agent[:version]
      return false if user_agent_version.nil? || user_agent_version == ''

      semantic = Semantic::Version.new(user_agent[:version])
      match_semantic_version(semantic, allow_higher: allow_higher)
    end

    def browser?
      target_browser = user_agent[:family].downcase
      queries.key?(target_browser)
    end

    private

    def user_agent
      Resolver.new(user_agent_string).call
    end

    def match_semantic_version(semantic, allow_higher:)
      queries[user_agent[:family].downcase].any? do |version|
        # Deal with "all" or nil version rule e.g. op_mini all (all semantic are match)
        return true if version == "all" || version.nil?
        # Deal with "TP" version rule e.g. Safari TP _ note there is no match if client is indeed TP
        return false if version == "TP"

        if allow_higher
          match_higher_version?(semantic, version)
        else
          match_version?(semantic, version)
        end
      end
    end

    def match_version?(semantic, query_version)
      if query_version.include?('-')
        low_version, high_version = query_version.split('-', 2)
        semantic.satisfied_by?([">= #{low_version}", "<= #{high_version}"])
      else
        semantic.satisfies?(query_version)
      end
    end

    def match_higher_version?(semantic, query_version)
      low_version = query_version.split('-', 2).first
      semantic.satisfies?(">= #{low_version}")
    end
  end
end
