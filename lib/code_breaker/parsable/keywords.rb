module CodeBreaker
  module Parsable
    module Keywords
      include Parsable::Node

      alias_method :parse_or_node,      :parse_as_hash
      alias_method :parse_and_node,     :parse_as_hash
      alias_method :parse_def_node,     :parse_as_hash
      alias_method :parse_yield_node,   :parse_as_hash
      alias_method :parse_rescue_node,  :parse_as_hash
      alias_method :parse_resbody_node, :parse_as_hash

      alias_method :parse_break_node,   :parse_as_node_type
      alias_method :parse_next_node,    :parse_as_node_type
      alias_method :parse_retry_node,   :parse_as_node_type
      alias_method :parse_self_node,    :parse_as_node_type

      def parse_loop_node(node)
        condition = node.children[0]
        body      = node.children[1]

        { node.type => parse(condition), do: parse(body) }
      end

      alias_method :parse_while_node, :parse_loop_node
      alias_method :parse_until_node, :parse_loop_node

      def parse_for_node(node)
        variable  = node.children[0]
        range     = node.children[1]
        body      = node.children[2]

        { node.type => parse(variable), in: parse(range), do: parse(body) }
      end

      def parse_if_node(node)
        condition = node.children[0]
        if_body   = node.children[1]
        else_body = node.children[2]

        clause = { node.type => parse(condition), then: parse(if_body) }
        clause[:else] = parse(else_body) if else_body

        clause
      end

      def parse_module_node(node)
        name  = parse(node.children[0])
        body  = node.children[1].nil? ? nil : parse(node.children[1])
        value = body ? [name, body] : [name]

        { node.type => value }
      end

      def parse_return_node(node)
        children = parse_children(node)
        values   = children.length == 1 ? children[0] : children

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

      def parse_case_node(node)
        case_part  = parse(node.children.first)
        when_parts = node.children[1...-1].map { |child| parse(child) }
        else_part  = parse(node.children.last)

        statement = { case: when_parts.unshift(case_part) }
        statement[:case] << { else: else_part } if else_part
        statement
      end

      def parse_when_node(node)
        when_part = parse(node.children[0])
        then_part = parse(node.children[1])

        { when: when_part, then: then_part }
      end
    end
  end
end
