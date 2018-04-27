module Browserslist
  module Useragent
    class UserAgent
      attr_reader :family, :version
      def initialize(family:, version:)
        @family = family
        @version = version
      end
    end
  end
end
