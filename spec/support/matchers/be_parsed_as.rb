require 'rspec/expectations'

RSpec::Matchers.define :be_parsed_as do |expected|
  match do |actual|
    CodeBreaker::Parser.new(actual).run == expected
  end

  failure_message do |actual|
    expected_message = %(expected "#{actual}" to be parsed as #{expected})
    actual_message   = %(got #{CodeBreaker::Parser.new(actual).run} instead)

    [expected_message, actual_message].join("\n")
  end
end
