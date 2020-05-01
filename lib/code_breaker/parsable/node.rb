module CodeBreaker
  module Parsable
    module Node
      def parse(node)
        if node.is_a?(Symbol)
          node
        elsif node.nil?
          parse_nil_node(node)
        else
          send("parse_#{node.type}_node", node)
        end
      end

      def parse_children(node, compact: true)
        children = node.children
        children = children.compact if compact

        children.each_with_object([]) do |child, nodes|
          nodes << parse(child)
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
        matches = method.to_s.match(/^parse_(.+)_node$/)
        node_type = matches ? matches.captures.first : []

        if node_type.empty?
          super
        else
          raise NotImplementedError, not_implemented_message(node_type)
        end
      end

      def not_implemented_message(node_type)
        [
          %(Breaking the node type "#{node_type}" is not yet implemented.),
          'You can open an issue on this in the project’s Github repo under:',
          'https://github.com/daigaku-ruby/code_breaker/issues/new',
          ''
        ].join("\n")
      end
    end
  end
end
