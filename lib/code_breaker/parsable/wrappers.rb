module CodeBreaker
  module Parsable
    module Wrappers
      include Parsable::Node

      def parse_send_node(node)
        if [:Rational, :Complex].include?(node.children[1])
          return Kernel.const_get(node.children[1].to_s)
        end

        parse_children(node).flatten(1)
      end

      alias_method :parse_begin_node, :parse_children
    end
  end
end
