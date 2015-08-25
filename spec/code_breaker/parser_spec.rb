require 'spec_helper'

describe CodeBreaker::Parser do

  let(:code_snippet) { 'sum = "2".to_i + 3' }
  let(:output) { [:sum, :'=', String, :to_i, :+, Fixnum] }

  subject { CodeBreaker::Parser.new(code_snippet) }

  it { is_expected.to respond_to :run }
  it { is_expected.to respond_to :input }
  it { is_expected.to respond_to :output }

  describe 'input' do
    it 'returns the code snippet the parser was instanciated with' do
      expect(subject.input).to eq code_snippet
    end
  end

  describe 'output' do
    it 'is an alias method for #run' do
      expect(subject.method(:output)).to eq subject.method(:run)
    end
  end

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

      context 'for root node representing a constant' do
        it 'returns the constant hash with the constant symbol' do
          parsed = CodeBreaker::Parser.new("Object").run
          expect(parsed).to eq({ const: :Object })
        end
      end

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

      context 'for a local variable assignment' do
        it 'returns a Hash with key :lvasgn (local variable assignment)' do
          input = "name = 'John Doe' + 24.to_s"
          output = { lvasgn: [:name, [String, :+, Fixnum, :to_s]] }

          parsed = CodeBreaker::Parser.new(input).run
          expect(parsed).to eq output
        end
      end
    end
  end
end
