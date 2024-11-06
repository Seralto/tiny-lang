# The Parser class will handle the syntax analysis and produce an AST (Abstract Syntax Tree).

class Parser
  # Initializes the parser with a lexer to get tokens from and
  # sets the first token as the current token.
  def initialize(lexer)
    @lexer = lexer
    @current_token = lexer.next_token
  end

  # Parses the entire input by iterating over tokens and generating statements,
  # forming an Abstract Syntax Tree (AST).
  def parse
    statements = []
    while @current_token
      statements << parse_statement
    end
    statements
  end

  private

  # Parses a single statement, which could be an assignment or an output statement.
  def parse_statement
    case @current_token.type
    when :IDENTIFIER
      parse_assignment
    when :OUT
      parse_out_statement
    else
      raise "Unexpected token: #{@current_token}"
    end
  end

  # Parses an assignment statement, identifying the variable being assigned and its value.
  def parse_assignment
    identifier = @current_token.value
    consume(:IDENTIFIER)
    consume(:EQUAL) if @current_token.type == :EQUAL
    value = parse_expression
    { type: :assignment, identifier: identifier, value: value }
  end

  # Parses an output statement, which prints the result of an expression.
  def parse_out_statement
    consume(:OUT)
    expression = parse_expression
    { type: :out, expression: expression }
  end

  # Parses an expression, handling addition and subtraction, and combines terms accordingly.
  def parse_expression
    left = parse_term

    while @current_token && (@current_token.type == :PLUS || @current_token.type == :MINUS)
      operator = @current_token.type
      consume(operator)
      right = parse_term
      left = { type: :binary_operation, operator: operator, left: left, right: right }
    end

    left
  end

  # Parses a term, handling multiplication and division, and combines factors accordingly.
  def parse_term
    left = parse_factor

    while @current_token && (@current_token.type == :ASTERISK || @current_token.type == :SLASH)
      operator = @current_token.type
      consume(operator)
      right = parse_factor
      left = { type: :binary_operation, operator: operator, left: left, right: right }
    end

    left
  end

  # Parses a factor, which can be a number, variable, string, or a parenthesized expression.
  def parse_factor
    if @current_token.type == :NUMBER
      value = @current_token.value.to_i
      consume(:NUMBER)
      { type: :number, value: value }
    elsif @current_token.type == :IDENTIFIER
      value = @current_token.value
      consume(:IDENTIFIER)
      { type: :identifier, value: value }
    elsif @current_token.type == :STRING
      value = @current_token.value
      consume(:STRING)
      { type: :string, value: value }
    elsif @current_token.type == :LPAREN
      consume(:LPAREN)
      expression = parse_expression
      consume(:RPAREN)
      expression
    else
      raise "Unexpected token: #{@current_token}"
    end
  end

  # Consumes the current token if it matches the expected type, then moves to the next token.
  def consume(expected_type)
    if @current_token.type == expected_type
      @current_token = @lexer.next_token
    else
      raise "Expected #{expected_type}, got #{@current_token.type}"
    end
  end
end