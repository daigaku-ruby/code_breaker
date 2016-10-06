module CodeBreaker
  module Parsable
    module VariableTypes
      include Parsable::Node

      alias_method :parse_const_node, :parse_as_last_child_hash

      # local variable
      alias_method :parse_lvar_node, :parse_as_last_child_hash

      # instance variable
      alias_method :parse_ivar_node, :parse_as_last_child_hash

      # class variable
      alias_method :parse_cvar_node, :parse_as_last_child_hash

      # global variable
      alias_method :parse_gvar_node, :parse_as_last_child_hash
    end
  end
end
