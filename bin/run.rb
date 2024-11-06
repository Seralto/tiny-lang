require_relative '../lib/lexer'
require_relative '../lib/parser'
require_relative '../lib/interpreter'

# Main entry point to run the interpreter
if ARGV.empty?
  puts "Usage: ruby run.rb <filename>"
  exit 1
end

filename = ARGV[0]

unless File.exist?(filename)
  puts "File not found: #{filename}"
  exit 1
end

# Read the input file
input = File.read(filename)

# Create Lexer, Parser, and Interpreter objects
lexer = Lexer.new(input)
parser = Parser.new(lexer)
ast = parser.parse
interpreter = Interpreter.new(ast)

# Interpret the AST
interpreter.interpret
