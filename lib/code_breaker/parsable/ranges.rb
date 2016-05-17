require 'active_support/concern'

module CodeBreaker
  module Parsable
    module Ranges
      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        # inclusive range a..b
        alias_method :parse_irange_node, :parse_as_hash

        # exclusive range a...b
        alias_method :parse_erange_node, :parse_as_hash
      end
    end
  end
end
