

interface --> REPL interface (keyboard bindings etc.) -->

  === Keyboard controls

  | `[Up/Down]           | Navigate history
  | `[Enter/Shift-Enter] | Evaluate an expression
  | `[Control-l]         | Clear the screen
  | `[Control-m]         | Toggle multiline mode


numbers --> Numeric values -->

  === Numbers

  Integers and floating point numbers can be written in decimal form
  with the usual syntax, e.g. /[10 + 89.99]. The semantics are the
  same as JavaScript.

  Number literals can be written in other bases with the
  `[<radix>r<int>.<frac>] syntax.

  | __Decimal       | / 1 / 1.4 / 4.93e51
  | __Hexadecimal   | / 16rFF / 16r100 / 16rDEADBEEF / 16r0.8
  | __[Binary etc.] | / 2r1110 / 3r20 / 36rZAZZ

  ==== Numerical operations

  | __Addition            | / 10 + 20
  | __Subtraction         | / 10 - 20
  | __Multiplication      | / 7 * 9
  | __Division            | / [10 / 3]
  | __[Integer division]  | / 10 // 3
  | __Modulo              | / 24 mod 7
  | __Exponentiation      | / 3 ** 3
  | __[Test if number]    | / Number? 31
  | __[Convert to number] | / Number! "31"


strings --> Strings -->

  === Strings

  Strings are delimited by quotation marks (`["]):

  / "Hello world!"

  The backslash \\ can be used to escape quotation marks or create
  special characters like line breaks:

  / "Hello, my name is \"Olivier\""

  / "Line 1\nLine 2\nLine 3"

  A string can span multiple lines:

  /
    "this is
     perfectly acceptable"

  As a shortcut, purely alphanumeric strings can be denoted with the
  dot operator: [/[.ABC]], [/[.Peter]], [/[.XYZ == "XYZ"]]. Note that
  if the string is an operator, for instance the `where operator, then
  it must be written `["where"] or `[.[where]].



variables --> Deciaring and setting variables -->

  === Variables

  | Declare __read-only | / let x = 1234
  | Declare __mutable   | / var x = 1234
  | __Set a variable    | / x = 1234

  Attempting to set a variable that has not yet been declared will
  create a __read-only variable in the local scope.

  .note ..
    __Note: as a convenience, all variables declared interactively in
    the top scope are in fact mutable.

  You can create blocks/[help blocks] with their own local variables
  using `[[]], `let or `where.

  / [[let a = 10, let b = 90, a + b]]

  / let [a = 10, b = 90]: a + b

  /
    a + b where
       a = 10
       b = 90

  Be are that `[[]] only creates a block when it encloses more than
  one expression. An indented block is completely equivalent to
  wrapping it in `[[]]~s.



