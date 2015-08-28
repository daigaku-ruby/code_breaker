require 'active_support/concern'

module CodeBreaker
  module Parsable
    module VariableTypes

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        def parse_const_node(node)
          { node.type => node.children.last }
        end
      end
    end
  end
end
