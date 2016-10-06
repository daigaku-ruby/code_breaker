module CodeBreaker
  module Parsable
    module Ranges
      include Parsable::Node

      # inclusive range a..b
      alias_method :parse_irange_node, :parse_as_hash

      # exclusive range a...b
      alias_method :parse_erange_node, :parse_as_hash
    end
  end
end
