require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    context 'for root node respresenting a send type' do
      [Rational, Complex].each do |number|
        it "returns #{number} for a #{number.to_s.downcase} number" do
          parsed = CodeBreaker::Parser.new("#{number}(2, 3)").run
          expect(parsed).to eq number
        end
      end
    end

    context 'for a simple method call on Objects' do
      it 'returns an Array with the classes and methods' do
        input = "1 + 3.5 * Rational(2,3) - Complex(1, 2)"
        output = [Fixnum, :+, Float, :*, Rational, :-, Complex]

        parsed = CodeBreaker::Parser.new(input).run
        expect(parsed).to eq output
      end

      describe 'with braces' do
        it 'returns a nested Array with the classes and methods' do
          input = "((1 + 3.5) - Rational(2,3)) * Complex(1, 2)"
          output = [[[Fixnum, :+, Float], :-, Rational], :*, Complex]

          parsed = CodeBreaker::Parser.new(input).run
          expect(parsed).to eq output
        end
      end
    end

  end
end
