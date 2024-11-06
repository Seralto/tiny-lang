# This will evaluate the AST produced by the parser.

class Interpreter
  # Initializes the interpreter with an AST and sets up a hash for variable storage.
  def initialize(ast)
    @ast = ast
    @variables = {}
  end

  # Interprets the AST by iterating over each statement and executing it.
  def interpret
    @ast.each do |statement|
      case statement[:type]
      when :assignment
        @variables[statement[:identifier]] = evaluate(statement[:value])
      when :out
        puts evaluate(statement[:expression])
      end
    end
  end

  private

  # Evaluates a node in the AST based on its type, handling numbers,
  # variables, strings, and binary operations.
  def evaluate(node)
    case node[:type]
    when :number
      node[:value]
    when :identifier
      @variables[node[:value]]
    when :string
      node[:value]
    when :binary_operation
      left = evaluate(node[:left])
      right = evaluate(node[:right])
      case node[:operator]
      when :PLUS
        left + right
      when :MINUS
        left - right
      when :ASTERISK
        left * right
      when :SLASH
        left / right
      else
        raise "Unknown operator: #{node[:operator]}"
      end
    else
      raise "Unknown node type: #{node[:type]}"
    end
  end
end
