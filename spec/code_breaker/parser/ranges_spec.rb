require 'spec_helper'

describe CodeBreaker::Parser do
  describe '#run' do
    context 'for a root node representing an inclusive range' do
      it 'returns a Hash with key :irange and the bounding types' do
        input  = "1.2..'impossible range, still parsed'"
        output = { irange: [Float, String] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing an exclusive range' do
      it 'returns a Hash with key :erange and the bounding types' do
        input  = '1.2...4'
        output = { erange: [Float, fixnum_or_integer] }
        expect(input).to be_parsed_as output
      end
    end

    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.7.0')
      context 'for a beginless inclusive range' do
        it 'returns a Hash with key :irange and the upper bounding type' do
        input = '..1.2'
        output = { irange: [NilClass, Float]}
        expect(input).to be_parsed_as output
        end
      end

      context 'for a beginless exclusive range' do
        it 'returns a Hash with key :erange and the upper bounding type' do
        input = '...1.2'
        output = { erange: [NilClass, Float]}
        expect(input).to be_parsed_as output
        end
      end
    end

    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.6.0')
      context 'for a endless inclusive range' do
        it 'returns a Hash with key :irange and the lower bounding type' do
        input = '1.2..'
        output = { irange: [Float, NilClass]}
        expect(input).to be_parsed_as output
        end
      end

      context 'for a endless exclusive range' do
        it 'returns a Hash with key :erange and the lower bounding type' do
        input = '1.2...'
        output = { erange: [Float, NilClass]}
        expect(input).to be_parsed_as output
        end
      end
    end
  end
end
