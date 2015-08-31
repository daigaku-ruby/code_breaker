require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    context 'for a root node representing an inclusive range' do
      it 'returns a Hash with key :irange and the bounding types' do
        input = "1.2..'impossible range, still parsed'"
        output = { irange: [Float, String] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing an exclusive range' do
      it 'returns a Hash with key :erange and the bounding types' do
        input = "1.2...4"
        output = { erange: [Float, Fixnum] }
        expect(input).to be_parsed_as output
      end
    end
  end
end
