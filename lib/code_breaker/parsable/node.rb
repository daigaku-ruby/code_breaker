module CodeBreaker
  module Parsable
    module Node

      def parse(node)
        if node.kind_of?(Symbol)
          node
        else
          send("parse_#{node.type}_node", node)
        end
      end

      def parse_children(node)
        node.children.reduce([]) do |nodes, child|
          nodes << parse(child)
        end
      end

      def parse_as_hash(node)
        { node.type => parse_children(node) }
      end

      def parse_as_last_child_hash(node)
        { node.type => node.children.last }
      end

    end
  end
end
