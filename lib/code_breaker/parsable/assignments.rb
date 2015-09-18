require 'active_support/concern'

module CodeBreaker
  module Parsable
    module Assignments

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        alias :parse_lvasgn_node :parse_as_hash # local variable assignment
        alias :parse_ivasgn_node :parse_as_hash # instance variable assignment
        alias :parse_cvasgn_node :parse_as_hash # class variable assignment
        alias :parse_gvasgn_node :parse_as_hash # global variable assignment
        alias :parse_op_asgn_node :parse_as_hash # operation assignment
        alias :parse_or_asgn_node :parse_as_hash # or assignment
        alias :parse_and_asgn_node :parse_as_hash # and assignment

        # multiple assignment
        def parse_masgn_node(node)
          lhs, rhs = parse_children(node)

          values = if rhs.kind_of?(Hash) && rhs.has_key?(:array)
            rhs[:array]
          else
            [rhs] + (1...lhs.count).map { NilClass }
          end

          { node.type => { lhs => values } }
        end

        # multiple left hand side
        def parse_mlhs_node(node)
          parse_children(node).map(&:values).flatten
        end

        # constant assignment
        def parse_casgn_node(node)
          name = node.children[1]
          children = node.children[2]
          value = children.nil? ? name : [name, parse(node.children[2])]

          { node.type => value }
        end

      end

    end
  end
end
