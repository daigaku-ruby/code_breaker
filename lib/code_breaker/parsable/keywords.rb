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

        def parse_if_node(node)
          condition = node.children[0]
          if_body = node.children[1]
          else_body = node.children[2]

          clause = { if: parse(condition), then: parse(if_body) }
          clause[:else] = parse(else_body) if else_body

          clause
        end
      end

    end
  end
end
