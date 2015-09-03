require 'code_breaker/parsable'
require 'parser/current'
require 'active_support/inflector'

module CodeBreaker
  class Parser
    include Parsable::Wrappers
    include Parsable::VariableTypes
    include Parsable::DataTypes
    include Parsable::Assignments
    include Parsable::Ranges
    include Parsable::Keywords
    include Parsable::LanguageElements

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
  end
end
