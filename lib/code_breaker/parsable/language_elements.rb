require 'active_support/concern'

module CodeBreaker
  module Parsable
    module LanguageElements

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        alias :parse_block_node :parse_as_hash
        alias :parse_args_node :parse_as_hash
        alias :parse_arg_node :parse_as_last_child_hash
        alias :parse_blockarg_node :parse_as_last_child_hash
        alias :parse_restarg_node :parse_as_last_child_hash
        alias :parse_optarg_node :parse_as_hash # optional argument

        def parse_block_pass_node(node)
          { block_pass: node.children.first.children.last }
        end
      end
    end
  end
end