module CodeBreaker
  module Parsable
    module Assignments
      include Parsable::Node

      # local variable assignment
      alias_method :parse_lvasgn_node, :parse_as_hash

      # instance variable assignment
      alias_method :parse_ivasgn_node, :parse_as_hash

      # class variable assignment
      alias_method :parse_cvasgn_node, :parse_as_hash

      # global variable assignment
      alias_method :parse_gvasgn_node, :parse_as_hash

      # operation assignment
      alias_method :parse_op_asgn_node, :parse_as_hash

      # or assignment
      alias_method :parse_or_asgn_node, :parse_as_hash

      # and assignment
      alias_method :parse_and_asgn_node, :parse_as_hash

      # multiple assignment
      def parse_masgn_node(node)
        lhs, rhs = parse_children(node)
        values   = multiple_assignment_values(lhs, rhs)

        { node.type => { lhs => values } }
      end

      # multiple left hand side
      def parse_mlhs_node(node)
        parse_children(node).map(&:values).flatten
      end

      # constant assignment
      def parse_casgn_node(node)
        name     = node.children[1]
        children = node.children[2]
        value    = children.nil? ? name : [name, parse(node.children[2])]

        { node.type => value }
      end

      private

      def multiple_assignment_values(lhs, rhs)
        if rhs.is_a?(Hash) && rhs.key?(:array)
          rhs[:array]
        else
          [rhs] + (1...lhs.count).map { NilClass }
        end
      end
    end
  end
end
