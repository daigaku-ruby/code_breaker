require 'code_breaker/version'
require 'code_breaker/parser'

module CodeBreaker

  def self.parse(code)
    CodeBreaker::Parser.new(code).run
  end
end
