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
        node.children.reduce([]) do |res, child|
          res << parse(child)
        end
      end

      def parse_as_hash(node)
        { node.type => parse_children(node) }
      end

    end
  end
end
