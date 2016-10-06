module CodeBreaker
  module Parsable
    module LanguageElements
      include Parsable::Node

      alias_method :parse_block_node,    :parse_as_hash
      alias_method :parse_args_node,     :parse_as_hash
      alias_method :parse_arg_node,      :parse_as_last_child_hash
      alias_method :parse_blockarg_node, :parse_as_last_child_hash
      alias_method :parse_restarg_node,  :parse_as_last_child_hash

      # optional argument
      alias_method :parse_optarg_node, :parse_as_hash

      # keyword argument
      alias_method :parse_kwarg_node, :parse_as_last_child_hash

      # optional keyword argument
      alias_method :parse_kwoptarg_node, :parse_as_hash

      # keyword rest argument
      alias_method :parse_kwrestarg_node, :parse_as_last_child_hash

      def parse_block_pass_node(node)
        { node.type => node.children.first.children.last }
      end

      def parse_splat_node(node)
        children = parse_children(node).flatten(1)
        values   = children.length == 1 ? children[0] : children

        { node.type => values }
      end
    end
  end
end
