require 'spec_helper'

describe CodeBreaker do
  it 'has a version number' do
    expect(CodeBreaker::VERSION).not_to be nil
  end

  describe '::parse' do
    it 'instanciates a new Parser and runs it' do
      allow_any_instance_of(CodeBreaker::Parser).to receive(:run) { 'parsed' }
      expect_any_instance_of(CodeBreaker::Parser).to receive(:run)

      result = CodeBreaker.parse('gem_name = "code_breaker"')
      expect(result).to eq 'parsed'
    end
  end
end
