require 'active_support/concern'

module CodeBreaker
  module Parsable
    module DataTypes

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        def parse_nil_node(node)
          NilClass
        end

        def parse_true_node(node)
          TrueClass
        end

        def parse_false_node(node)
          FalseClass
        end

        def parse_str_node(node)
          String
        end

        # interpolated executed string
        def parse_xstr_node(node)
          { node.type => parse_children(node).first }
        end

        def parse_sym_node(node)
          Symbol
        end

        def parse_float_node(node)
          Float
        end

        def parse_regexp_node(node)
          Regexp
        end

        def parse_int_node(node)
          node.children[0].class
        end

        def parse_hash_node(node)
          { node.type => parse_children(node).inject(:merge).to_h }
        end

        def parse_pair_node(node)
          { parse(node.children[0]) => parse(node.children[1]) }
        end

        alias :parse_array_node :parse_as_hash
      end
    end
  end
end
