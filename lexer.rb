# The Lexer class is responsible for breaking down the input source code
# into tokens that can be used by the parser.

class Lexer
  KEYWORDS = ['out']

  Token = Struct.new(:type, :value)

  # Initializes the lexer with the input source code and sets the starting position to 0.
  def initialize(input)
    @input = input
    @position = 0
  end

  # Retrieves the next token from the input by skipping whitespace and matching known patterns.
  def next_token
    skip_whitespace
    return nil if @position >= @input.length

    case current_char
    when '(' then create_token(:LPAREN, advance)
    when ')' then create_token(:RPAREN, advance)
    when '+' then create_token(:PLUS, advance)
    when '-' then create_token(:MINUS, advance)
    when '*' then create_token(:ASTERISK, advance)
    when '/' then create_token(:SLASH, advance)
    when '=' then create_token(:EQUAL, advance)
    when '"' then tokenize_string
    when /^[a-zA-Z_]$/ then tokenize_identifier
    when /^[0-9]$/ then tokenize_number
    else
      raise "Unexpected character: #{current_char}"
    end
  end

  private

  # Returns the current character at the current position in the input.
  def current_char
    @input[@position]
  end

  # Moves the position forward by one character and returns the character that was advanced over.
  def advance
    char = current_char
    @position += 1
    char
  end

  # Creates a new token with the specified type and value.
  def create_token(type, value)
    Token.new(type, value)
  end

  # Skips over any whitespace characters to move to the next significant character.
  def skip_whitespace
    @position += 1 while current_char =~ /\s/
  end

  # Handles identifiers and keywords. Advances through valid characters,
  # checks if the value is a keyword, and creates a corresponding token.
  def tokenize_identifier
    start_pos = @position
    advance while current_char =~ /[a-zA-Z0-9_]/
    value = @input[start_pos...@position]
    type = KEYWORDS.include?(value) ? value.upcase.to_sym : :IDENTIFIER
    create_token(type, value)
  end

  # Handles numeric values. Advances through all digits and creates a NUMBER token.
  def tokenize_number
    start_pos = @position
    advance while current_char =~ /[0-9]/
    value = @input[start_pos...@position]
    create_token(:NUMBER, value)
  end

  # Handles string literals enclosed in double quotes.
  # Advances through all characters until the closing quote and creates a STRING token.
  def tokenize_string
    advance # Skip the opening quote
    start_pos = @position
    advance while current_char != '"'
    value = @input[start_pos...@position]
    advance # Skip the closing quote
    create_token(:STRING, value)
  end
end
