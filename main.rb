require 'pry'

require_relative './lib/lexer'
require_relative './lib/parser'
require_relative './lib/interpreter'

input = <<~INPUT
  x = 5
  y = 10
  z = 2
  out x + y * z
  out "Hello, World!"
  out (x + y) * z
INPUT

lexer = Lexer.new(input)
parser = Parser.new(lexer)
ast = parser.parse
interpreter = Interpreter.new(ast)
interpreter.interpret