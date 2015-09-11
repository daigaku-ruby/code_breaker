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

    context 'for a root node representing a method definition' do
      context 'without arguments' do
        it 'returns a Hash with key :def and the method name, args and body' do
          input = "def greet\n'Hello!'\nend"
          output = { def: [:greet, { args: []}, String] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with arguments' do
        it 'returns a Hash with key :def and the method name, args and body' do
          input = "def greet(name)\n'Hello' + name + '!'\nend"
          output = {
            def: [
              :greet,
              { args: [{ arg: :name }] },
              [String, :+, { lvar: :name }, :+, String]
            ]
          }

          expect(input).to be_parsed_as output
        end
      end

      context 'without a body' do
        it 'returns a Hash with key :def and the method name and args' do
          input = "def greet(name)\n\nend"
          output = {
            def: [
              :greet,
              { args: [{ arg: :name }] }
            ]
          }

          expect(input).to be_parsed_as output
        end
      end
    end

    context 'for a root node representing a module definition' do
      context 'without a body' do
        it 'return a Hash with key :module and the name value' do
          input = "module Breakable\nend"
          output = { module: [{ const: :Breakable }] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with a body' do
        it 'returns a Hash with key :module and the name and body as value' do
          input = "module Breakable\nCONST = 1\nOTHER_CONST='a'.freeze\nend"
          output = {
            module: [
              { const: :Breakable },
              [
                { casgn: [:CONST, Fixnum] },
                { casgn: [:OTHER_CONST, [String, :freeze]] }
              ]
            ]
          }

          expect(input).to be_parsed_as output
        end
      end
    end

    context 'for a root node representing a return' do
      it 'returns a Hash with key :return and the returned value' do
        input = "return 3"
        output = { return: Fixnum }
        expect(input).to be_parsed_as output
      end

      it 'returns a Hash with key :return and the returned values as Array' do
        input = "return 3 + 2"
        output = { return: [Fixnum, :+, Fixnum] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a yield' do
      it 'returns a Hash with key :yield and the types of given arguments' do
        input = "yield(3, 'beer')"
        output = { yield: [Fixnum, String] }
        expect(input).to be_parsed_as output
      end

      it 'returns a Hash with key :yield and value [] without arguments' do
        input = "yield"
        output = { yield: [] }
        expect(input).to be_parsed_as output
      end
    end

  end
end
