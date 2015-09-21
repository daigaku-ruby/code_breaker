require 'active_support/concern'

module CodeBreaker
  module Parsable
    module VariableTypes

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        alias :parse_const_node :parse_as_last_child_hash
        alias :parse_lvar_node :parse_as_last_child_hash # local variable
        alias :parse_ivar_node :parse_as_last_child_hash # instance variable
        alias :parse_cvar_node :parse_as_last_child_hash # class variable
        alias :parse_gvar_node :parse_as_last_child_hash # global variable
      end
    end
  end
end
