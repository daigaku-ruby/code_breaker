require 'spec_helper'

describe CodeBreaker::Parser do

  describe '#run' do
    context 'for a local variable assignment' do
      it 'returns a Hash with key :lvasgn' do
        input = "name = 'John Doe' + 24.to_s"
        output = { lvasgn: [:name, [String, :+, Fixnum, :to_s]] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for an instance variable assignment' do
      it 'returns a Hash with key :ivasgn' do
        input = "@name = 'John Doe' + 24.to_s"
        output = { ivasgn: [:@name, [String, :+, Fixnum, :to_s]] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a class variable assignment' do
      it 'returns a Hash with key :cvasgn' do
        input = "@@name = 'John Doe' + 24.to_s"
        output = { cvasgn: [:@@name, [String, :+, Fixnum, :to_s]] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a global variable assignment' do
      it 'returns a Hash with key :cvasgn' do
        input = "$name = 'John Doe' + 24.to_s"
        output = { gvasgn: [:'$name', [String, :+, Fixnum, :to_s]] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for a multiple variable assignment' do
      it 'returns an assignment hash if RHS is an Array' do
        input = "x, y = ['holy', 108]"
        output = { masgn: { [:x, :y] => [String, Fixnum] } }
        expect(input).to be_parsed_as output
      end

      it 'returns an assignment hash if RHS is a variable list' do
        input = "x, y = 'holy', 108"
        output = { masgn: { [:x, :y] => [String, Fixnum] } }
        expect(input).to be_parsed_as output
      end

      it 'returns an assignment hash if RHS is a single variable' do
        input = "x, y = 'single'"
        output = { masgn: { [:x, :y] => [String, NilClass] } }
        expect(input).to be_parsed_as output
      end
    end

    context 'for an operation assignment' do
      it 'returns a Hash with key :op_asgn' do
        input = "a += 1"
        output = { op_asgn: [{ lvasgn: [:a] }, :+, Fixnum] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for an or assignment' do
      it 'returns a Hash with key :or_asgn' do
        input = "a ||= true"
        output = { or_asgn: [{ lvasgn: [:a] }, TrueClass] }
        expect(input).to be_parsed_as output
      end
    end

    context 'for an and assignment' do
      it 'returns a Hash with key :and_asgn' do
        input = "a &&= true"
        output = { and_asgn: [{ lvasgn: [:a] }, TrueClass] }
        expect(input).to be_parsed_as output
      end
    end

  end
end
