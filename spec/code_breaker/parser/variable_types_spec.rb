require 'spec_helper'

describe CodeBreaker::Parser do
  describe '#run' do
    context 'for a root node representing a constant' do
      it 'returns the constant hash with the constant symbol' do
        expect('Object').to be_parsed_as(const: :Object)
      end
    end

    context 'for a root node representing an instance variable' do
      it 'returns a Hash with the key ivar and the variable name' do
        expect('@a').to be_parsed_as(ivar: :@a)
      end
    end

    context 'for a root node representing a class variable' do
      it 'returns a Hash with the key cvar and the variable name' do
        expect('@@a').to be_parsed_as(cvar: :@@a)
      end
    end

    context 'for a root node representing a global variable' do
      it 'returns a Hash with the key gvar and the variable name' do
        expect('$a').to be_parsed_as(gvar: :$a)
      end
    end

    context 'for a root node representing a local variable' do
      it 'returns a Hash with the key lvar and the variable name' do
        parsed = CodeBreaker::Parser.new('a = 1; a;').run
        expect(parsed.last).to eq(lvar: :a)
      end
    end
  end
end
