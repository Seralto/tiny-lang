require_relative '../lib/lexer'
require_relative '../lib/parser'
require 'rspec'

describe Parser do
  let(:lexer) { Lexer.new(input) }
  let(:parser) { Parser.new(lexer) }

  context 'when parsing assignment' do
    let(:input) { 'x = 5' }

    it 'parses an assignment statement correctly' do
      ast = parser.parse
      expect(ast).to eq([{ type: :assignment, identifier: 'x', value: { type: :number, value: 5 } }])
    end
  end

  context 'when parsing output statement' do
    let(:input) { 'out "Hello"' }

    it 'parses an output statement correctly' do
      ast = parser.parse
      expect(ast).to eq([{ type: :out, expression: { type: :string, value: 'Hello' } }])
    end
  end

  context 'when parsing binary operations' do
    let(:input) { 'out 3 + 4 * 2' }

    it 'parses binary operations with correct precedence' do
      ast = parser.parse
      expect(ast).to eq([
        {
          type: :out,
          expression: {
            type: :binary_operation,
            operator: :PLUS,
            left: { type: :number, value: 3 },
            right: {
              type: :binary_operation,
              operator: :ASTERISK,
              left: { type: :number, value: 4 },
              right: { type: :number, value: 2 }
            }
          }
        }
      ])
    end
  end
end