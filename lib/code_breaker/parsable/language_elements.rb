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
        alias :parse_kwarg_node :parse_as_last_child_hash # keyword argument
        alias :parse_kwoptarg_node :parse_as_hash # optional keyword argument
        alias :parse_kwrestarg_node :parse_as_last_child_hash # keyword rest argument

        def parse_block_pass_node(node)
          { node.type => node.children.first.children.last }
        end

        def parse_splat_node(node)
          children = parse_children(node).flatten(1)
          values = children.length == 1 ? children[0] : children

          { node.type =>  values }
        end
      end
    end
  end
end