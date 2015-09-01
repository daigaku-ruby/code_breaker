require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    ['||', 'or'].each do |connector|
      context "for a root node representing an #{connector} connection" do
        it 'returns a Hash with key :or and the connected children' do
          input = "1.to_s #{connector} 5.5"
          output = { or: [[Fixnum, :to_s], Float] }
          expect(input).to be_parsed_as output
        end
      end
    end

    ['&&', 'and'].each do |connector|
      context "for a root node representing an #{connector} connection" do
        it 'returns a Hash with key :and and the connected children' do
          input = "1.to_s #{connector} 5.5"
          output = { and: [[Fixnum, :to_s], Float] }
          expect(input).to be_parsed_as output
        end
      end
    end

    context 'for a root node representing an if clause' do
      context 'with only an if clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input = "'2'.to_i if 2 == '2'"
          output = { if: [Fixnum, :==, String], then: [String, :to_i] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with an if/then clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input = "if 2 == '2' then '2'.to_i end"
          output = { if: [Fixnum, :==, String], then: [String, :to_i] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with an if/else clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input = "if 2 == '2' then '2'.to_i else Rational(2, 3).to_s end"
          output = {
            if: [Fixnum, :==, String],
            then: [String, :to_i],
            else: [Rational, :to_s]
          }

          expect(input).to be_parsed_as output
        end
      end

      context 'with an if/elsif clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input = "if 2 == '2' then '2'.to_i elsif true then Object.new end"
          output = {
            if: [Fixnum, :==, String],
            then: [String, :to_i],
            else: {
              if: TrueClass,
              then: [{ const: :Object }, :new]
            }
          }

          expect(input).to be_parsed_as output
        end
      end
    end

  end
end
