require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    context 'for root node representing a constant' do
      it 'returns the constant hash with the constant symbol' do
        parsed = CodeBreaker::Parser.new("Object").run
        expect(parsed).to eq({ const: :Object })
      end
    end
  end
end
