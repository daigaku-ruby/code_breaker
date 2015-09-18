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
          nodes << parse(child) unless child.nil?
          nodes
        end
      end

      def parse_as_hash(node)
        { node.type => parse_children(node) }
      end

      def parse_as_last_child_hash(node)
        { node.type => node.children.last }
      end

      def parse_as_node_type(node)
        node.type
      end

      def method_missing(method, *args, &block)
        node_type = method.to_s.match(/^parse_(.+)_node$/).captures.first

        if node_type.empty?
          super
        else
          message = [
            "Breaking the node type \"#{node_type}\" is not yet implemented.",
            "You can open an issue on this in the project's Github repo under:",
            "https://github.com/daigaku-ruby/code_breaker/issues/new\n"
          ].join("\n")

          raise NotImplementedError, message
        end
      end

    end
  end
end
