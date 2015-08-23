require 'parser/current'
require 'active_support/inflector'

module CodeBreaker
  class Parser

    attr_reader :input

    def initialize(code)
      @input = code.to_s.strip
    end

    def run
      @output ||= parse(@input)
    end

    alias :output :run

    private

    def parse(input)
      ast = ::Parser::CurrentRuby.parse(input)

      if variable_assignment?(ast)
        parse_variable_assignment(ast)
      else
        parse_statement(ast)
      end
    end

    def variable_assignment?(ast)
      ast.loc.node.type == :lvasgn
    end

    def parse_variable_assignment(ast)
      nodes = ast.loc.node.children[1].children
      result = parse_nodes(nodes)
      cleanup(result).flatten(1).unshift(ast.loc.node.children[0], :'=')
    end

    def parse_statement(ast)
      nodes = ast.loc.node.children
      result = parse_nodes(nodes)
      cleanup(result).flatten(1)
    end

    def parse_nodes(nodes)
      nodes.map do |node|
        node.respond_to?(:children) ? parse_nodes(node.children).to_a : node
      end
    end

    def cleanup(nodes)
      nodes.map do |node|
        if node.kind_of?(Symbol)
          node
        elsif node.kind_of?(Array)
          if node.length > 1
            node[0].nil? ? node[1].to_s.constantize : cleanup(node)
          elsif node[0].kind_of?(Array)
            cleanup(node)
          else
            node[0].class
          end
        else
          node.class
        end
      end
    end
  end
end
