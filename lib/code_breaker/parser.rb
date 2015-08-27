require 'parser/current'
require 'active_support/inflector'

module CodeBreaker
  class Parser

    attr_reader :input

    def initialize(code)
      @input = code.to_s.strip
    end

    def run
      unless @output
        ast = ::Parser::CurrentRuby.parse(input)
        @output = parse(ast.loc.node)
      end

      @output
    end

    alias :output :run

    private

    def parse(node)
      if node.kind_of?(Symbol)
        node
      else
        send("parse_#{node.type}_node", node)
      end
    end

    def parse_children(node)
      node.children.reduce([]) do |res, child|
        res << parse(child)
      end
    end

    def parse_as_hash(node)
      { node.type => parse_children(node) }
    end

    alias :parse_begin_node   :parse_children
    alias :parse_array_node   :parse_as_hash
    alias :parse_lvasgn_node  :parse_as_hash  # local variable assignment
    alias :parse_irange_node  :parse_as_hash  # inclusive range a..b
    alias :parse_erange_node  :parse_as_hash  # exclusive range a..b

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

    def parse_sym_node(node)
      Symbol
    end

    def parse_float_node(node)
      Float
    end

    def parse_int_node(node)
      node.children[0].class
    end

    def parse_const_node(node)
      { node.type => node.children.last }
    end

    def parse_send_node(node)
      if [:Rational, :Complex].include?(node.children[1])
        return node.children[1].to_s.constantize
      end

      parse_children(node).flatten(1)
    end

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
      parse_children(node).map { |var| var.values }.flatten
    end

    def parse_hash_node(node)
      { node.type => parse_children(node).inject(:merge).to_h }
    end

    def parse_pair_node(node)
      { parse(node.children[0]) => parse(node.children[1]) }
    end
  end
end
