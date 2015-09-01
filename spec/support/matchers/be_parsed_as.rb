require 'rspec/expectations'

RSpec::Matchers.define :be_parsed_as do |expected|
  match do |actual|
    CodeBreaker::Parser.new(actual).run == expected
  end

  failure_message do |actual|
    %Q{expected "#{actual}" to be parsed as #{expected}\n} +
    %Q{got #{CodeBreaker::Parser.new(actual).run} instead}
  end
end
