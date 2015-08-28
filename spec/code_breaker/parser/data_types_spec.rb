require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    context 'for root node representing a basic type' do
      {
        "nil"       => NilClass,
        "true"      => TrueClass,
        "false"     => FalseClass,
        "'string'"  => String,
        ":symbol"   => Symbol,
        "3.5"       => Float,
        "1"         => Fixnum,
        "4_611_686_018_427_387_904" => Bignum
      }.each do |input, output|
        it "returns #{output} for #{input}" do
          parsed = CodeBreaker::Parser.new("#{input}").run
          expect(parsed).to eq output
        end
      end
    end

    context 'for a root node representing an Array' do
      it 'returns a Hash with key :array and an Array of items' do
        input = "[1, 'apple', :a, Day]"
        output = { array: [Fixnum, String, Symbol, { const: :Day }] }

        parsed = CodeBreaker::Parser.new(input).run
        expect(parsed).to eq output
      end
    end

    context 'for a root node representing a Hash' do
      it 'returns a Hash with key :hash and a Hash of key/type pairs' do
        input = "{ euro: '€', 'dollar' => 1.1521 }"
        output = { hash: { Symbol => String, String => Float } }

        parsed = CodeBreaker::Parser.new(input).run
        expect(parsed).to eq output
      end
    end
  end
end
