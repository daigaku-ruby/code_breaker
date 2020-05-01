require 'spec_helper'

describe CodeBreaker::Parser do
  describe '#run' do
    ['||', 'or'].each do |connector|
      context "for a root node representing an #{connector} connection" do
        it 'returns a Hash with key :or and the connected children' do
          input  = "1.to_s #{connector} 5.5"
          output = { or: [[fixnum_or_integer, :to_s], Float] }
          expect(input).to be_parsed_as output
        end
      end
    end

    ['&&', 'and'].each do |connector|
      context "for a root node representing an #{connector} connection" do
        it 'returns a Hash with key :and and the connected children' do
          input  = "1.to_s #{connector} 5.5"
          output = { and: [[fixnum_or_integer, :to_s], Float] }
          expect(input).to be_parsed_as output
        end
      end
    end

    context 'for a root node representing an if clause' do
      context 'with only an if clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input  = "'2'.to_i if 2 == '2'"
          output = { if: [fixnum_or_integer, :==, String], then: [String, :to_i] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with an if/then clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input  = "if 2 == '2' then '2'.to_i end"
          output = { if: [fixnum_or_integer, :==, String], then: [String, :to_i] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with an if/else clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input  = "if 2 == '2' then '2'.to_i else Rational(2, 3).to_s end"
          output = {
            if: [fixnum_or_integer, :==, String],
            then: [String, :to_i],
            else: [Rational, :to_s]
          }

          expect(input).to be_parsed_as output
        end
      end

      context 'with an if/elsif clause' do
        it 'returns a Hash with key :if and the if clause body' do
          input  = "if 2 == '2' then '2'.to_i elsif true then Object.new end"
          output = {
            if: [fixnum_or_integer, :==, String],
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
          input  = "def greet\n'Hello!'\nend"
          output = { def: [:greet, { args: [] }, String] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with arguments' do
        it 'returns a Hash with key :def and the method name, args and body' do
          input  = "def greet(name)\n'Hello' + name + '!'\nend"
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
          input  = "def greet(name)\n\nend"
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
          input  = "module Breakable\nend"
          output = { module: [{ const: :Breakable }] }
          expect(input).to be_parsed_as output
        end
      end

      context 'with a body' do
        it 'returns a Hash with key :module and the name and body as value' do
          input  = "module Breakable\nCONST = 1\nOTHER_CONST = 'a'.freeze\nend"
          output = {
            module: [
              { const: :Breakable },
              [
                { casgn: [:CONST, fixnum_or_integer] },
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
        input  = 'return 3'
        output = { return: fixnum_or_integer }
        expect(input).to be_parsed_as output
      end

      it 'returns a Hash with key :return and the returned values as Array' do
        input  = 'return 3 + 2'
        output = { return: [fixnum_or_integer, :+, fixnum_or_integer] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a yield' do
      it 'returns a Hash with key :yield and the types of given arguments' do
        input  = "yield(3, 'beer')"
        output = { yield: [fixnum_or_integer, String] }
        expect(input).to be_parsed_as output
      end

      it 'returns a Hash with key :yield and value [] without arguments' do
        input  = 'yield'
        output = { yield: [] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a while loop' do
      it 'returns a Hash with key :while and the loop body under :do key' do
        input  = "while true == false do\nputs 'You did the impossible!'\nend"
        output = { while: [TrueClass, :==, FalseClass], do: [:puts, String] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a until loop' do
      it 'returns a Hash with key :until and the loop body under :do key' do
        input  = "until true == false do\nputs 'You did the impossible!'\nend"
        output = { until: [TrueClass, :==, FalseClass], do: [:puts, String] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a for loop' do
      it 'returns a Hash with key :for and the loop body under :do key' do
        input  = "for i in 1..5 do\nputs i\nend"
        output = {
          for: { lvasgn: [:i] },
          in: { irange: [fixnum_or_integer, fixnum_or_integer] },
          do: [:puts, { lvar: :i }]
        }

        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a break instruction' do
      it 'returns a :break symbol' do
        expect('break').to be_parsed_as :break
      end
    end

    context 'for a root node representing a next instruction' do
      it 'returns a :next symbol' do
        expect('next').to be_parsed_as :next
      end
    end

    context 'for a root node representing a retry instruction' do
      it 'returns a :retry symbol' do
        expect('retry').to be_parsed_as :retry
      end
    end

    context 'for a root node representing a self instruction' do
      it 'returns a :self symbol' do
        expect('self').to be_parsed_as :self
      end
    end

    context 'for a root node representing a begin instruction' do
      describe 'without a rescue statement' do
        it 'returns a Hash with key :begin and the body as value' do
          input  = "begin puts '' end"
          output = { begin: [:puts, String] }
          expect(input).to be_parsed_as output
        end
      end

      describe 'with a rescue statement' do
        it 'returns a Hash with keys :begin and :rescue and its bodies' do
          input  = "begin\n  raise Exception.new \nrescue\n  puts 'hm...'\nend"
          output = {
            begin: [:raise, { const: :Exception }, :new],
            rescue: [:puts, String]
          }

          expect(input).to be_parsed_as output
        end
      end
    end

    context 'for a root node representing a case statement' do
      describe 'with else part' do
        it 'returns a Hash with key :case and its when/then/else hashs as value' do
          input  = "state = :new\ncase state\n  when :new then 1.to_s\n  when :old then 2.to_s\nelse\n 3 end"
          output = [
            { lvasgn: [:state, Symbol] },
            {
              case: [
                { lvar: :state },
                { when: Symbol, then: [fixnum_or_integer, :to_s] },
                { when: Symbol, then: [fixnum_or_integer, :to_s] },
                { else: fixnum_or_integer }
              ]
            }
          ]

          expect(input).to be_parsed_as output
        end
      end

      describe 'without else part' do
        it 'returns a Hash with key :case and its when/then hashs as value' do
          input  = "state = :new\ncase state\n  when :new then 1.to_s\n  when :old then 2.to_s\nend"
          output = [
            { lvasgn: [:state, Symbol] },
            {
              case: [
                { lvar: :state },
                { when: Symbol, then: [fixnum_or_integer, :to_s] },
                { when: Symbol, then: [fixnum_or_integer, :to_s] },
                { else: NilClass }
              ]
            }
          ]

          expect(input).to be_parsed_as output
        end
      end
    end
  end
end
