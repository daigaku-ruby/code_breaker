require 'spec_helper'

describe CodeBreaker::Parser do

  let(:code_snippet) { 'gem_name = "code_breaker"' }
  subject { CodeBreaker::Parser.new(code_snippet) }

  it { is_expected.to respond_to :run }
  it { is_expected.to respond_to :input }
  it { is_expected.to respond_to :output }

  describe '#run' do
    it 'returns an Array' do
      expect(subject.run).to be_an Array
    end

    context 'for code snippets defining a variable' do
      it 'returns the called classes and methods of the right hand side' do
        code_snippet = 'number = 1 + 2.3 - Rational(2,3) * Complex(0.4, 0.2)'
        expected_result = [Fixnum, :+, Float, :-, Rational, :*, Complex]
        actual_result = CodeBreaker::Parser.new(code_snippet).run

        expect(actual_result).to eq expected_result
      end
    end
  end
end
