require 'spec_helper'

describe CodeBreaker::Parser do

  let(:code_snippet) { 'sum = "2".to_i + 3' }
  let(:output) { [String, :to_i, :+, Fixnum] }

  subject { CodeBreaker::Parser.new(code_snippet) }

  it { is_expected.to respond_to :run }
  it { is_expected.to respond_to :input }
  it { is_expected.to respond_to :output }

  describe 'input' do
    it 'returns the code snippet the parser was instanciated with' do
      expect(subject.input).to eq code_snippet
    end
  end

  describe 'output' do
    it 'is an alias method for #run' do
      expect(subject.method(:output)).to eq subject.method(:run)
    end
  end

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
