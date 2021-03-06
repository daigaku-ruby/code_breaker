require 'spec_helper'

describe CodeBreaker::Parser do
  describe '#run' do
    context 'for root node representing a basic type' do
      {
        'nil'       => NilClass,
        'true'      => TrueClass,
        'false'     => FalseClass,
        '"string"'  => String,
        ':symbol'   => Symbol,
        '3.5'       => Float,
        '/^R+uby$/' => Regexp
      }.each do |input, output|
        it "returns #{output} for #{input}" do
          expect(input).to be_parsed_as output
        end
      end

      it 'returns Integer for integers' do
        expect(1).to be_parsed_as Integer
        expect(4_611_686_018_427_387_904).to be_parsed_as Integer
      end
    end

    context 'for a root node representing an Array' do
      it 'returns a Hash with key :array and an Array of items' do
        input  = "[1, 'apple', :a, Day]"
        output = { array: [Integer, String, Symbol, { const: :Day }] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a Hash' do
      it 'returns a Hash with key :hash and a Hash of key/type pairs' do
        input  = "{ euro: '€', 'dollar' => 1.1521 }"
        output = { hash: [{ Symbol => String }, { String => Float }] }
        expect(input).to be_parsed_as output
      end

      it 'returns a Hash with key :hash and a Hash of key/type pairs' do
        input  = "{ euro: '€', dollar: 1.1521 }"
        output = { hash: [{ Symbol => String }, { Symbol => Float }] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing an interpolated executed string' do
      it 'returns a Hash with key :xstr and value String' do
        input  = '%x{string}'
        output = { xstr: String }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing an interpolated string' do
      it 'returns a Hash with key :dstr and an Array of interpolation values' do
        input  = '"#{1 + 2} interpolated string #{\'here\'}"'
        output = { dstr: [[Integer, :+, Integer], String, [String]] }
        expect(input).to be_parsed_as output
      end
    end
  end
end
