require 'active_support/concern'

module CodeBreaker
  module Parsable
    module Keywords

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        alias :parse_or_node      :parse_as_hash
        alias :parse_and_node     :parse_as_hash
        alias :parse_def_node     :parse_as_hash
        alias :parse_module_node  :parse_as_hash
        alias :parse_yield_node   :parse_as_hash

        alias :parse_break_node :parse_as_node_type
        alias :parse_next_node  :parse_as_node_type
        alias :parse_retry_node :parse_as_node_type
        alias :parse_self_node  :parse_as_node_type
        alias :parse_rescue_node  :parse_as_hash
        alias :parse_resbody_node  :parse_as_hash

        def parse_loop_node(node)
          condition = node.children[0]
          body = node.children[1]

          { node.type => parse(condition), do: parse(body) }
        end

        alias :parse_while_node :parse_loop_node
        alias :parse_until_node :parse_loop_node

        def parse_for_node(node)
          variable  = node.children[0]
          range     = node.children[1]
          body      = node.children[2]

          { node.type => parse(variable), in: parse(range), do: parse(body) }
        end

        def parse_if_node(node)
          condition = node.children[0]
          if_body = node.children[1]
          else_body = node.children[2]

          clause = { node.type => parse(condition), then: parse(if_body) }
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

        def parse_kwbegin_node(node)
          rescue_given = node.children.first.type == :rescue

          if rescue_given
            rescue_part = parse(node.children.first)[:rescue]

            {
              begin: rescue_part.first,
              rescue: rescue_part.last[:resbody].first
            }
          else
            { begin: parse(node.children.last) }
          end
        end
      end

    end
  end
end
