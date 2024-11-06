require_relative '../lib/lexer'
require 'rspec'

describe Lexer do
  let(:lexer) { Lexer.new(input) }

  context 'when tokenizing keywords' do
    let(:input) { 'out' }

    it 'returns the correct token for keyword' do
      token = lexer.next_token
      expect(token.type).to eq(:OUT)
      expect(token.value).to eq('out')
    end
  end

  context 'when tokenizing identifiers' do
    let(:input) { 'variableName' }

    it 'returns the correct token for an identifier' do
      token = lexer.next_token
      expect(token.type).to eq(:IDENTIFIER)
      expect(token.value).to eq('variableName')
    end
  end

  context 'when tokenizing numbers' do
    let(:input) { '123' }

    it 'returns the correct token for a number' do
      token = lexer.next_token
      expect(token.type).to eq(:NUMBER)
      expect(token.value).to eq('123')
    end
  end

  context 'when tokenizing strings' do
    let(:input) { '"Hello, World!"' }

    it 'returns the correct token for a string' do
      token = lexer.next_token
      expect(token.type).to eq(:STRING)
      expect(token.value).to eq('Hello, World!')
    end
  end

  context 'when tokenizing symbols' do
    let(:input) { '( ) + - * / =' }

    it 'returns the correct tokens for symbols' do
      expected_tokens = [
        [:LPAREN, '('],
        [:RPAREN, ')'],
        [:PLUS, '+'],
        [:MINUS, '-'],
        [:ASTERISK, '*'],
        [:SLASH, '/'],
        [:EQUAL, '=']
      ]

      expected_tokens.each do |type, value|
        token = lexer.next_token
        expect(token.type).to eq(type)
        expect(token.value).to eq(value)
      end
    end
  end

  context 'when tokenizing complex input' do
    let(:input) { 'out "Hello" + 123' }

    it 'returns the correct sequence of tokens' do
      tokens = []
      while (token = lexer.next_token)
        tokens << token
      end

      expect(tokens.map(&:type)).to eq([:OUT, :STRING, :PLUS, :NUMBER])
      expect(tokens.map(&:value)).to eq(['out', 'Hello', '+', '123'])
    end
  end
end
