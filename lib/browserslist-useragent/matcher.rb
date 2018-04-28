require 'semantic'

module Browserslist
  module Useragent
    # Checks matching of browserslist queies array to the user agent string
    class Matcher
      attr_reader :queries, :user_agent

      def initialize(queries, user_agent)
        @user_agent = user_agent
        @queries = queries.each_with_object([]) do |query, arr|
          arr.push(::Browserslist::Useragent::QueryNormalizer.new(query).call)
        end
      end

      def match?
        agent = resolver.call
        queries.any? do |query|
          if match_user_agent?(agent[:family], query[:family])
            ua_semantic = Semantic::Version.new(agent[:version])

            query_version = query[:version]
            if query_version.include?('-')
              low_version, hight_version = query_version.split('-', 2)
              ua_semantic.satisfies?(">= #{low_version}") &&
                ua_semantic.satisfies?("<= #{hight_version}")
            else
              ua_semantic.satisfies?(query[:version])
            end
          end
        end
      end

      def family?
        agent = resolver.call
        queries.any? do |query|
          match_user_agent?(agent[:family], query[:family])
        end
      end

      private

      def resolver
        @resolver ||= Resolver.new(user_agent)
      end

      def match_user_agent?(a, b)
        a.casecmp(b).zero?
      end
    end
  end
end
