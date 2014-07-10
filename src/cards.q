
tut0 ->

  === Keyboard controls

  | `[Up/Down]           | Navigate history
  | `[Enter/Shift-Enter] | Evaluate an expression
  | `[Control-l]         | Clear the screen
  | `[Control-m]         | Toggle multiline mode

  Type /next to continue with the tutorial.


tut1 ->

  === Basics

  Click on boxes like /this to evaluate their contents.

  ==== Strings

  / "hello world" / .word / "My name is \"Olivier\""

  ==== Numbers

  | __Decimal       | / 1 / 1.4 / 4.93e51
  | __Hex           | / 16rFF / 16r100 / 16rDEADBEEF / 16r0.8
  | __[Binary etc.] | / 2r1110 / 3r20 / 36rZAZZ

  ==== Function calls

  | __Call    | / alert{"Hello!"} / alert with "Hello!"
  | __Methods | [/ "hello".substring{1}]

  /next => variables


tut2 ->

  === Variables (boom)

  | Declare __read-only | / let x = 1234
  | Declare __mutable   | / var x = 1234
  | __Set a variable    | / x = 1234

  Attempting to set a variable that has not yet been declared will
  create a __read-only variable in the local scope.

  .note ..
    __Note: as a convenience, all variables declared interactively in
    the top scope are in fact mutable.

  You can create blocks with their own local variables using `[[]],
  `let or `where.

  / [[let a = 10, let b = 90, a + b]]

  / let [a = 10, b = 90]: a + b

  / a + b where
       a = 10
       b = 90

  Be are that `[[]] only creates a block when it encloses more than
  one expression. An indented block is completely equivalent to
  wrapping it in `[[]]~s.

  /next => data structures


catatouille ->

  === Cats
  
  Here are some properties of sweet cats:
  * Cute
  * /[Cuddly .cute]
  * Really, _really evil!
  
  What

  Is

  Up


