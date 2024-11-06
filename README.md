# TinyLang

As the name implies, TinyLang is a tiny interpreted language written in Ruby for didactic purpose.

## Lexer

The **Lexer** is responsible for breaking down the source code into smaller parts called **tokens**, which are used by the **parser** to understand the code's structure. Here's how it works step-by-step:

1. **Initialization (`initialize`)**:

   - The Lexer is initialized with the input source code.
   - It starts reading from position 0.

2. **Getting the Next Token (`next_token`)**:

   - This method reads the input character by character to determine the next token.
   - It skips whitespace using the `skip_whitespace` method.
   - Depending on the current character, it identifies different types of tokens:
     - **Symbols**: `(`, `)`, `+`, `-`, `*`, `/`, `=` create corresponding tokens.
     - **Identifiers and Keywords**: Uses `tokenize_identifier` to distinguish between variable names and keywords like `out`.
     - **Numbers**: Uses `tokenize_number` to identify numeric values.
     - **Strings**: Uses `tokenize_string` to handle text enclosed in double quotes.
   - If it encounters an unexpected character, it raises an error.

3. **Helper Methods**:

   - **`current_char`**: Returns the character at the current position.
   - **`advance`**: Moves the position forward by one character and returns the current character.
   - **`create_token`**: Creates a new token with a specified type and value.
   - **`skip_whitespace`**: Skips over any whitespace characters to reach the next significant character.

4. **Tokenizing Specific Elements**:
   - **`tokenize_identifier`**: Handles variables and keywords. It reads characters that form an identifier (letters, numbers, underscores) and creates an identifier or keyword token.
   - **`tokenize_number`**: Handles numeric values. It reads all digit characters and creates a `NUMBER` token.
   - **`tokenize_string`**: Handles string literals enclosed in double quotes. It reads all characters until the closing quote and creates a `STRING` token.

The **Lexer** processes each part of the input code to generate a list of tokens, which are essential for the **parser** to understand the meaning of the code and build a structure that the **interpreter** can execute.

## Parser

The **Parser** flow starts by breaking down the input into statements and expressions, creating an Abstract Syntax Tree (AST) to represent the structure of the code. Here’s a step-by-step explanation:

1. **Initialization (`initialize`)**:

   - The parser is initialized with a `Lexer` object that provides tokens from the source code.
   - The first token is retrieved and stored as the current token.

2. **Parsing the Input (`parse`)**:

   - The `parse` method creates a list (`statements`) to hold all parsed statements.
   - It continuously calls `parse_statement` until all tokens are consumed.

3. **Parsing Statements (`parse_statement`)**:

   - Depending on the current token type, it decides if it’s an assignment or an output (`out`) statement.
   - If it's an identifier, it proceeds with `parse_assignment`.
   - If it's an `OUT` token, it proceeds with `parse_out_statement`.

4. **Parsing Assignments (`parse_assignment`)**:

   - Identifies the variable name and expects an `=` sign.
   - Parses the value assigned to the variable by calling `parse_expression`.
   - Returns a hash representing the assignment.

5. **Parsing Output Statements (`parse_out_statement`)**:

   - Consumes the `OUT` token.
   - Parses the following expression using `parse_expression`.
   - Returns a hash representing the output statement.

6. **Parsing Expressions (`parse_expression`)**:

   - Parses a term using `parse_term`.
   - Handles addition (`+`) or subtraction (`-`) if they appear, combining terms as necessary.
   - Creates a node representing a binary operation if needed.

7. **Parsing Terms (`parse_term`)**:

   - Parses a factor using `parse_factor`.
   - Handles multiplication (`*`) or division (`/`), combining factors accordingly.
   - Similar to `parse_expression`, a binary operation node is created if an operator is found.

8. **Parsing Factors (`parse_factor`)**:

   - Handles individual components like numbers, identifiers (variables), strings, or parentheses.
   - For numbers and strings, it directly returns a value node.
   - If the current token is an opening parenthesis (`(`), it recursively calls `parse_expression` to handle nested expressions, then consumes the closing parenthesis (`)`).

9. **Consume Method (`consume`)**:
   - Ensures that the current token matches the expected type.
   - Advances to the next token if the match is correct, otherwise raises an error.

The `Parser` processes each piece of input and constructs a structured representation (AST) that the `Interpreter` can use to evaluate or execute the code.

INPUT

```ruby
input = <<~INPUT
  x = 5
  y = 2
  out x + y
INPUT
```

AST

```ruby
[
  {
    :type => :assignment,
    :identifier => "x",
    :value => {
      :type => :number,
      :value => 5
    }
  },
  {
    :type => :assignment,
    :identifier => "y",
    :value => {
      :type => :number,
      :value => 2
    }
  },
  {
    :type => :out,
    :expression => {
      :type => :binary_operation,
      :operator => :PLUS,
      :left => {
        :type => :identifier,
        :value => "x"
      },
      :right => {
        :type => :identifier,
        :value => "y"
      }
    }
  }
]
```

## Interpreter

The **Interpreter** class is responsible for executing the Abstract Syntax Tree (AST) produced by the parser. Let's walk through the flow:

1. **Initialization (`initialize`)**:

   - The interpreter is initialized with the AST, which represents the parsed structure of the code.
   - It also sets up a hash (`@variables`) to store variable values during execution.

2. **Interpreting the AST (`interpret`)**:

   - The `interpret` method iterates over each statement in the AST and performs actions based on the statement type.
   - For each statement, it checks if it's an assignment (`:assignment`) or an output (`:out`) and executes accordingly:
     - **Assignment**: Evaluates the assigned value and stores it in the `@variables` hash under the appropriate identifier.
     - **Output**: Evaluates the given expression and prints the result.

3. **Evaluating Nodes (`evaluate`)**:
   - The `evaluate` method is used to compute the value of different nodes in the AST.
   - The node type determines what kind of value is being processed:
     - **`:number`**: Simply returns the numeric value.
     - **`:identifier`**: Looks up the value of a variable in the `@variables` hash.
     - **`:string`**: Returns the string value.
     - **`:binary_operation`**: Evaluates both left and right sides of the operation, and then performs the appropriate arithmetic operation (`+`, `-`, `*`, `/`).
   - If the node type is unknown, it raises an error.

The interpreter essentially executes the high-level commands represented by the AST, managing variables, evaluating expressions, and producing output as specified by the source code. This involves traversing the AST, evaluating nodes, and carrying out instructions based on their type.

## Tests

Run

`bundle exec rspec spec`
