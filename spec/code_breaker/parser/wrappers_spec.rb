require 'spec_helper'

describe CodeBreaker::Parser do
  describe '#run' do
    context 'for root node respresenting a send type' do
      [Rational, Complex].each do |number|
        it "returns #{number} for a #{number.to_s.downcase} number" do
          input = "#{number}(2, 3)"
          expect(input).to be_parsed_as number
        end
      end
    end

    context 'for a simple method call on Objects' do
      it 'returns an Array with the classes and methods' do
        input  = '1 + 3.5 * Rational(2,3) - Complex(1, 2)'
        output = [fixnum_or_integer, :+, Float, :*, Rational, :-, Complex]
        expect(input).to be_parsed_as output
      end

      describe 'with braces' do
        it 'returns a nested Array with the classes and methods' do
          input  = '((1 + 3.5) - Rational(2,3)) * Complex(1, 2)'
          output = [[[fixnum_or_integer, :+, Float], :-, Rational], :*, Complex]
          expect(input).to be_parsed_as output
        end
      end
    end
  end
end
