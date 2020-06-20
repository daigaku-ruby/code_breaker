require 'spec_helper'

describe CodeBreaker::Parser do
  describe '#run' do
    context 'for a root node representing a block with one argument' do
      it 'returns a Hash with key :block and a [receiver, args, call] array' do
        input  = '5.times { |n| n.to_s }'
        output = {
          block: [
            [Integer, :times],
            { args: [{ arg: :n }] },
            [{ lvar: :n }, :to_s]
          ]
        }

        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a block with multiple args' do
      it 'returns a Hash with key :block and a [receiver, args, call] array' do
        input  = '[1, 2].reduce(0) { |sum, n| sum += n }'
        output = {
          block: [
            [{ array: [Integer, Integer] }, :reduce, Integer],
            { args: [{ arg: :sum }, { arg: :n }] },
            { op_asgn: [{ lvasgn: [:sum] }, :+, { lvar: :n }] }
          ]
        }

        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a block pass' do
      it 'returns an array with a Hash with the :block_pass key' do
        input  = '[1, 2].map &:to_s'
        output = [{ array: [Integer, Integer] }, :map, { block_pass: :to_s }]
        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a block argument' do
      it 'returns a Hash with key :blockarg and the argument name' do
        input  = "def greet(name, &block)\n'hello!'\nend"
        output = {
          def: [
            :greet,
            { args: [{ arg: :name }, { blockarg: :block }] },
            String
          ]
        }

        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing a rest argument' do
      it 'returns a Hash with key :restarg and the argument name' do
        input  = "def greet(name, *args)\n'hello!'\nend"
        output = {
          def: [
            :greet,
            { args: [{ arg: :name }, { restarg: :args }] },
            String
          ]
        }

        expect(input).to be_parsed_as output
      end
    end

    context 'for a root node representing an optional argument' do
      it 'returns a Hash with key :optarg and the argument name' do
        input  = "def greet(name, options = {a: 1})\n'hello!'\nend"
        output = {
          def: [
            :greet,
            {
              args: [
                { arg: :name },
                { optarg: [:options, { hash: [{ Symbol => Integer }] }] }
              ]
            },
            String
          ]
        }

        expect(input).to be_parsed_as output
      end

      context 'for a root node representing a keyword argument' do
        it 'returns a Hash with key :kwarg and the argument name' do
          input  = "def greet(title:, name:)\n\nend"
          output = {
            def: [
              :greet,
              { args: [{ kwarg: :title }, { kwarg: :name }] }
            ]
          }

          expect(input).to be_parsed_as output
        end
      end

      context 'for a root node representing an optional keyword argument' do
        it 'returns a Hash with key :kwoptarg and the argument name and type' do
          input  = "def greet(title: 'Mr.')\n\nend"
          output = {
            def: [
              :greet,
              { args: [{ kwoptarg: [:title, String] }] }
            ]
          }

          expect(input).to be_parsed_as output
        end
      end

      context 'for a root node representing a rest keyword argument' do
        it 'returns a Hash with key :kwrestarg and the argument name' do
          input  = "def greet(name:, **opts)\n\nend"
          output = {
            def: [
              :greet,
              { args: [{ kwarg: :name }, { kwrestarg: :opts }] }
            ]
          }

          expect(input).to be_parsed_as output
        end
      end

      context 'for a root node representing a splat operator' do
        it 'returns a Hash with key :splat and the splat values' do
          input  = 'puts(*[1,2])'
          output = [:puts, { splat: { array: [Integer, Integer] } }]
          expect(input).to be_parsed_as output
        end
      end
    end
  end
end
