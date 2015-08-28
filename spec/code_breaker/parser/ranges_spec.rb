require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    context 'for a root node representing an inclusive range' do
      it 'returns a Hash with key :irange and the bounding types' do
        input = "1.2..'impossible range, still parsed'"
        output = { irange: [Float, String] }

        parsed = CodeBreaker::Parser.new(input).run
        expect(parsed).to eq output
      end
    end

    context 'for a root node representing an exclusive range' do
      it 'returns a Hash with key :erange and the bounding types' do
        input = "1.2...4"
        output = { erange: [Float, Fixnum] }

        parsed = CodeBreaker::Parser.new(input).run
        expect(parsed).to eq output
      end
    end
  end
end
