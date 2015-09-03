require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    context 'for a root node representing a block with one argument' do
      it 'returns a Hash with key :block and a [receiver, args, call] array' do
        input = '5.times { |n| n.to_s }'
        output = {
          block: [
            [Fixnum, :times],
            { args: [{ arg: :n }] },
            [{ lvar: :n }, :to_s]
          ]
        }

        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a block with multiple args' do
      it 'returns a Hash with key :block and a [receiver, args, call] array' do
        input = '[1, 2].reduce(0) { |sum, n| sum += n }'
        output = {
          block: [
            [{ array: [Fixnum, Fixnum] }, :reduce, Fixnum],
            { args: [{ arg: :sum }, { arg: :n}] },
            { op_asgn: [{ lvasgn: [:sum] }, :+, { lvar: :n }] }
          ]
        }

        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a block pass' do
      it 'returns an array with a Hash with the :block_pass key' do
        input = '[1, 2].map &:to_s'
        output = [{ array: [Fixnum, Fixnum] }, :map, { block_pass: :to_s }]
        expect(input).to be_parsed_as output
      end
    end

  end
end