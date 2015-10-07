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

        # interpolated string
        def parse_dstr_node(node)
          values = parse_as_hash(node)[node.type].map do |value|
            if value.kind_of?(Array)
              value.flatten(1)
            else
              value
            end
          end

          { node.type => values }
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

        def parse_pair_node(node)
          { parse(node.children[0]) => parse(node.children[1]) }
        end

        alias :parse_hash_node :parse_as_hash
        alias :parse_array_node :parse_as_hash
      end
    end
  end
end
