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
      parsed_ast = ::Parser::CurrentRuby.parse(input)
      nodes = parsed_ast.loc.node.children[1].children
      result = parse_nodes(nodes)
      cleanup(result)
    end

    def parse_nodes(nodes)
      nodes.map do |node|
        node.respond_to?(:children) ? parse_nodes(node.children).to_a : node
      end
    end

    def cleanup(nodes)
      result = nodes.map do |node|
        if node.kind_of?(Symbol)
          node
        elsif node.kind_of?(Array) && node.length == 1
          node[0].class
        elsif node.kind_of?(Array)
          node[0].nil? ? node[1].to_s.constantize : cleanup(node)
        end
      end

      result.flatten
    end
  end
end
