require 'parser/current'
require 'active_support/inflector'

module CodeBreaker
  class Parser

    attr_reader :input, :output

    def initialize(code)
      @input = code.to_s.strip
    end

    def run
      parsed = ::Parser::CurrentRuby.parse(@input)
      nodes = parsed.loc.node.children
      children = nodes[1].children

      result = parse(children)
      @output = cleanup(result)
    end

    private

    def parse(nodes)
      nodes.map do |node|
        node.respond_to?(:children) ? parse(node.children).to_a : node
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
