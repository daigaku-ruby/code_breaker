require 'spec_helper'

describe CodeBreaker::Parser do
  let(:code_snippet) { 'sum = "2".to_i + 3' }

  subject { CodeBreaker::Parser.new(code_snippet) }

  it { is_expected.to respond_to :run }
  it { is_expected.to respond_to :input }
  it { is_expected.to respond_to :output }

  context 'for an empty string as input' do
    it 'returns an empty array' do
      expect('').to be_parsed_as []
    end
  end

  context 'for a comment as input' do
    it 'returns an empty array' do
      expect('# a comment').to be_parsed_as []
    end
  end

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
end
