require 'active_support/concern'

module CodeBreaker
  module Parsable
    module Keywords

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        alias :parse_or_node :parse_as_hash
        alias :parse_and_node :parse_as_hash
        alias :parse_def_node :parse_as_hash
        alias :parse_module_node :parse_as_hash

        def parse_if_node(node)
          condition = node.children[0]
          if_body = node.children[1]
          else_body = node.children[2]

          clause = { if: parse(condition), then: parse(if_body) }
          clause[:else] = parse(else_body) if else_body

          clause
        end

        def parse_module_node(node)
          name = parse(node.children[0])
          body = node.children[1].nil? ? nil : parse(node.children[1])
          value = body ? [name, body] : [name]

          { node.type => value }
        end

        def parse_return_node(node)
          children = parse_children(node)
          values = children.length == 1 ? children[0] : children

          { node.type => values }
        end
      end

    end
  end
end
