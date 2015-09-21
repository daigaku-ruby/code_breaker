require 'active_support/concern'

module CodeBreaker
  module Parsable
    module Ranges

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        alias :parse_irange_node :parse_as_hash # inclusive range a..b
        alias :parse_erange_node :parse_as_hash # exclusive range a...b
      end
    end
  end
end
