require 'active_support/concern'

module CodeBreaker
  module Parsable
    module Wrappers

      extend ActiveSupport::Concern
      include Parsable::Node

      included do
        def parse_send_node(node)
          if [:Rational, :Complex].include?(node.children[1])
            return node.children[1].to_s.constantize
          end

          parse_children(node).flatten(1)
        end

        alias :parse_begin_node   :parse_children
      end
    end
  end
end
