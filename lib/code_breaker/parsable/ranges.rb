module CodeBreaker
  module Parsable
    module Ranges
      include Parsable::Node

      # inclusive range a..b, a.., ..b
      def parse_irange_node(node)
        { node.type => parse_children(node, compact: false) }
      end

      # exclusive range a...b, a..., ...b
      def parse_erange_node(node)
        { node.type => parse_children(node, compact: false) }
      end
    end
  end
end
