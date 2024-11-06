# This file defines the Token structure and token types for the lexer.

class Token
  attr_reader :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end

  def to_s
    "<#{@type}, #{@value}>"
  end
end

# Define all the token types used by the lexer.
module TokenType
  # Single-character tokens
  LPAREN = :LPAREN      # (
  RPAREN = :RPAREN      # )
  PLUS = :PLUS          # +
  MINUS = :MINUS        # -
  ASTERISK = :ASTERISK  # *
  SLASH = :SLASH        # /
  EQUAL = :EQUAL        # =

  # Literals
  IDENTIFIER = :IDENTIFIER
  NUMBER = :NUMBER
  STRING = :STRING

  # Keywords
  OUT = :OUT
end
