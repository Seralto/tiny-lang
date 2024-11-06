require 'rspec'

require_relative '../lexer'
require_relative '../parser'
require_relative '../interpreter'

describe Interpreter do
  let(:lexer) { Lexer.new(input) }
  let(:parser) { Parser.new(lexer) }
  let(:ast) { parser.parse }
  let(:interpreter) { Interpreter.new(ast) }

  context 'when interpreting assignments and output' do
    let(:input) { "x = 10\nout x" }

    it 'assigns variables and outputs their values' do
      expect { interpreter.interpret }.to output("10\n").to_stdout
    end
  end

  context 'when interpreting arithmetic operations' do
    let(:input) { 'out (2 + 3) * 4' }

    it 'evaluates and outputs the result of arithmetic expressions' do
      expect { interpreter.interpret }.to output("20\n").to_stdout
    end
  end

  context 'when interpreting strings' do
    let(:input) { 'out "Hello, World!"' }

    it 'outputs the string correctly' do
      expect { interpreter.interpret }.to output("Hello, World!\n").to_stdout
    end
  end
end