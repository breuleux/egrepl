

help --> Main help -->

  == The Earl Grey programming language

  [__ Earl Grey] is a new language that compiles to JavaScript. It's a
  bit of a mad cross of CoffeeScript (as a transpiler), Python (colons
  and significant indent) and Racket (pattern matching and macros).

  Why should you care? Good question!

  * A quirky, terse /?syntax
  * Advanced [pattern matching]/?patterns
  * Arbitrary new features can be defined with /?macros

  === The REPL

  To your right there is an [__ interactive interpreter] in which you
  can try out the language.

  | `Enter or `[Shift-Enter]  | Evaluate an expression
  | `[Ctrl-Enter]             | Insert a new line
  | `[Up/Down]                | Navigate history
  | `[Control-l]              | Clear the screen

  [__ Click these boxes]/[1 + 1] to execute expressions in the
  interactive interpreter (`[Shift-click] to paste them without
  executing them).

  Type /help to display this page again if you lose it. You can also
  view the index here/?index or by typing /help.index, and a selected
  list of /?topics (/help.topics).

  Or you can look at /?examples~!

  === Links

  * [Source code]::https://github.com/breuleux/earl-grey


topics --> Selected topics -->

  == Selected topics

  === Basic topics

  /? numbers / strings / variables


  The /?index contains a list of all help topics.



interface --> REPL interface (keyboard bindings etc.) -->

  == Keyboard controls

  | `[Up/Down]           | Navigate history
  | `[Shift-Enter]       | Evaluate an expression
  | `[Ctrl-Enter]        | Insert a new line
  | `[Control-l]         | Clear the screen

  `Enter will evaluate the current expression if the cursor is on the
  last line of input and the current indent level is zero or the
  previous line is blank.


brackets --> The semantics of brackets -->

  == The semantics of brackets in Earl Grey

  Brackets in EG are certainly "odd", in the sense that they don't
  follow conventional semantics: blocks are defined using indent or
  `[[]] (instead of the conventional `{}), grouping expressions is
  done with `[[]] (instead of the conventional `()), function calls
  are done as `f{} (instead of the conventional `f()).

  First, let me say that it _is really strange at first, but you do
  get used to it (or at least I did).

  Second, this scheme is not accidental. There a _logic behind it
  which I will explain here. Basically, there are two types of
  brackets:

  # __[Data brackets] define data structures: arrays, objects, lists
    of arguments, and so on. EG uses `{} as data brackets.

  # __[Grouping brackets] disambiguate priority when necessary and can
    group several expressions into "blocks". EG uses `[[]] as grouping
    brackets.

  These simple and consistent semantics cut down the complexity of
  abstract syntax because they are not context sensitive. For
  instance, /[parseInt{"101", 2}] can also be written as
  /[args = {"101", 2}, parseInt args]. This kind of referential
  transparency is uncommon in mainstream programming languages.

  .note ..

    Since `[[]] is only for grouping, /[parseInt args] is the same
    thing as /[parseInt[args]]. Indeed, in EG, function application is
    a special case of indexing where the index is an array.

  Unfortunately, the way parentheses are used in conventional
  languages is incompatible with this scheme. The least confusing way
  to go about this issue is to not use parentheses at all, because it
  is easier to avoid using them wrong when it is always wrong to use
  them. Square brackets are a natural choice for grouping because it
  preserves conventional indexing syntax.

  === Recovering the standard semantics for parentheses

  Parentheses are currently illegal tokens, but that needs not be the
  case forever. By mapping `f(expr) to `f{expr} and `(expr) to
  `[[expr]], conventional syntax can be supported as syntactic sugar.

  The reason why I did not do it is that I am not sure that sugar is
  foolproof and I want to test the "pure" version of the language
  first. I invite everyone to give EG's bracket scheme a fair
  shot. The consistency is pretty neat, especially if you write
  macros.

  Alternatively, the sugar could be implemented in the text editors
  themselves, translating parentheses as they are typed. I will
  definitely consider the feedback I get on this matter.



syntax --> Syntax overview -->

  == Syntax overview

  Superficially, Earl Grey looks a lot like Python, if function calls
  used curly braces instead of parentheses.

  This is arguably the most salient difference between EG and almost
  all other language in use today: the only brackets you will find are
  curly and square. Parentheses are illegal tokens (for the moment: I
  keep my options open). The explanation is here/?brackets.

  _syntax_longif1 <-
    /
      if 1 + 1 == 2:
         then: true
         else: false

  _syntax_longif2 <-
    /
      if 1 + 1 == 2:
         x = 5
         x + x

  _syntax_longmatch <-
    /
      match:
         when 1 == 0 -> false
         when 1 == 1 -> true
         when 1 == 2 -> false
         else -> false

  _syntax_longwhile <-
    /
      i = 10
      while i > 0:
         i -= 1

  === Sugar rules

  * __Newlines: every newline is equivalent to a comma unless the next
    line starts with a backslash.

  * __Indent: every indented block is equivalent to a `[[]] block. See
    /?blocks.

  * __Colon: `[a: b] is equivalent to `a{b} and `[a b: c] is
    equivalent to `a{b, c}.

  * /?with

  === Overview

  | /?strings and /?numbers | / "hello world" / .word / 12.34e56 / 16rDEADBEEF
  | /?arrays           | / {1, 2, 3} / {} / #word{4, 5}
  | /?objects          | / {a = 1, b = 2} / {"x" => 3} / {=}
  | __Indexing         | / {1, 2}[0] / {a = 3}["a"]
  | __Arithmetic       | / [2 * 7 + 3 * -4]
  | __Grouping         | / [2 * [7 + 3] * -4]
  | __Blocks           | / [[x = 1, y = 2, x + y]]
  | __[Function calls] | / parseInt{"ZZZ", 36}
  | /?variables        | / [xyz = 123] / [var www = 456]
  | __Definitions      | / double{x} = x + x
  | __Lambdas          | / double = {x} -> x + x
  | loops/?each        | / 1..10 each i -> i * i
  | __Conditionals     | /if{1 + 1 == 2, true, false} (expression form)
  |                    | {_syntax_longif1}
  |                    | {_syntax_longif2} (`then is implicit)
  |                    | {_syntax_longmatch} (use /match if there are many conditions to test)
  | __[While loops]    | {_syntax_longwhile}



numbers --> Numeric values -->

  == Numbers

  Integers and floating point numbers can be written in decimal form
  with the usual syntax, e.g. /[10 + 89.99]. The semantics are the
  same as JavaScript.

  Number literals can be written in other bases with the
  `[<radix>r<int>.<frac>] syntax.

  | __Decimal       | / 1 / 1.4 / 4.93e51
  | __Hexadecimal   | / 16rFF / 16r100 / 16rDEADBEEF / 16r0.8
  | __[Binary etc.] | / 2r1110 / 3r20 / 36rZAZZ

  === Numerical operations

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

  == Strings

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



variables --> Declaring and setting variables -->

  == Variables

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



arrays --> Arrays -->

  == Arrays

  Arrays are one of EG's basic data structures (the other being
  /?objects). Arrays are a list of elements, declared with curly
  braces:

  / {1, 2, 3} / {.hello, {.nested, {.arrays}}} / {}

  They can be indexed using `[[]] brackets. The first element is at
  index 0. Accessing elements out of an array's bounds returns the
  value `undefined.

  /
    xs = {10, 88, 51, 24}
    xs[0] + xs[1]

  arrays_push  <- push /
    x = {1, 2, 3}
    x.push{4}
    x
  arrays_shift <- shift /
    x = {1, 2, 3}
    {x.shift{}, x}
  arrays_slice <- slice / {10, 88, 51, 24}.slice{1}

  Arrays have the same methods as in JavaScript ({arrays_push},
  {arrays_shift}, {arrays_slice}, etc.) You can look them up. In
  addition to these, the `[++] operator can be used to concatenate
  arrays: /[{1, 2} ++ {3, 4, 5}].

  It is also possible to __splice an array into another:

  /
    xs = {.x, .y, .z}
    {1, 2, *xs, 3, 4}

  /[#word{"arg1", "arg2"}] is syntactic sugar for
  /{"word", "arg1", "arg2"}.



objects --> Objects -->

  == Objects

  Arrays are one of EG's basic data structures (the other being
  /?arrays). Objects associate keys (which are always strings) to
  values. They are declared with curly braces and the `[=] or `[=>]
  operators
  
  .tip ..
    * Use `[=] if the key is a valid variable name.
    * Use `[=>] if the key is not known at compile time.

  / {a = 1, b = 2} / {"x" + "y" => 7} / {=}
  (the empty object)

  Fields can be accessed using dot notation, `[[]]~s, or simple
  juxtaposition:

  /
    obj = {a = .dirt, b = .treasure, c = .dirt}
    {obj.b, obj["b"], obj"b", obj[.b]}

  "Methods" can be declared very easily, like normal functions. When
  calling a method, the object is provided through the implicit `this
  variable.

  /
    counter = {
       _count = 0
       count{} =
          this._count += 1
    }
    1..10 each _ -> counter.count{}

  Objects can be __merged with the `[&] operator. The operator creates
  a new object that contains key\/value pairs from both operands.

  / {a = 1, c = 3} & {b = 2, d = 4} 

  For a more structured way to create objects, see /?class.

  


with --> The `with operator -->

  == The `with operator

  The `with operator in EG has __nothing to do with JavaScript's `with
  operator. In EG, `with basically lets you "pull" a sub-expression
  out of a larger expression to make it more readable. In a nutshell:

  long <-
    /
      zip with
         {1, 2, 3}
         {4, 5, 6}

  + `with expression               + Equivalent to:
  | /[parseInt with "61"]          | /parseInt{"61"}
  | /[parseInt{"101"} with 2]      | /parseInt{"101", 2}
  | /[parseInt{..., 2} with "101"] | /parseInt{"101", 2}
  | {long}                         | /zip{{1, 2, 3}, {4, 5, 6}}

  For more details, see the advanced help page for with/?with2.



where --> The `where operator -->

  == The `where operator

  `where can be used to declare variables that are local to some
  expression.

  / setTimeout{f, 1000} where f{} = alert{"One second later..."}

  /
    [a*a + b*b] ** 0.5 where
       a = 3
       b = 4

  Note that the bindings for /f, /a and /b are only valid in the
  `where expression. `where always lets you shadow existing variables
  and it even lets you shadow standard operators:

  / 8 + 12 where a + b = a - b

  Evaluating that expression has no ill effects on the rest of the
  program, as you can verify: /[8 + 12].



each --> The `each operator -->

  == The `each operator

  `each iterates a function over an array. If it is in expression
  position, it also accumulates results into a new array.

  / {1, 2, 3, 4, 5} each i -> i * i

  /
    items{{a = 1, b = 2, c = 3}} each {key, value} ->
       String{value} + key

  __[List comprehensions]: an array can be filtered using a `when
  clause:

  / 1..10 each i when i mod 2 == 0 -> i

  __[Using multiple clauses]: the right hand side of `each can contain
  multiple clauses (in fact, any valid body for a /?match statement is
  also valid for `each).

  /
    {12, "bear", "lemon", 332} each
       Number? n -> n + 1
       String? s -> s + "s"

  FizzBuzz /
    1..100 each
       i when i mod 15 == 0 -> "FizzBuzz"
       i when i mod 3 == 0 -> "Fizz"
       i when i mod 5 == 0 -> "Buzz"
       i -> i

  .note ..
    Only a trailing `when clause will cause `each to filter elements:
    other clause types will throw an exception if a match is not found
    and there are no more clauses to try.

  === Helper functions (useful with `each)

  * [items/items{{a = 1, b = 2, c = 3}}]: make an array of key\/value
    pairs from an object.
  * [enumerate/enumerate{{.x, .y, .z}}]: build an array of
    `{index, value} pairs.
  * [zip/zip{{1, 2, 3}, {4, 5, 6}}]: interleave the elements
    of two arrays.
  * [/ 1..10]: create an inclusive range.



deconstruction --> Deconstructing data structures -->

  == Deconstructing data structures

  Extracting fields from arrays and objects can be sometimes
  tedious. Argument deconstruction makes this easier. Arrays as well
  as objects can be deconstructed:

  /
    {a, b, c} = {1, 2, 3}
    a + b + c

  /
    {=> x, => y} = {x = 4, y = 5}
    x + y

  === Deconstructing into objects

  Arrays and objects can be deconstructed into objects just as well as
  into variables (this is particularly useful for examples because you
  get a nice table!)

  / {{a, b} = {1, 2}}

  / {{x => y, y => x} = {x = 1, y = 2}}
  (the format is `[source_field => dest_field])

  / {{a, {b, c}, {=> d}} = {1, {2, 3}, {d = 4}}}

  === Default and rest arguments

  Remember that you can remove the outer curly brackets if you want to
  put the results in variables instead of into an object.

  / {{one, two, three = null} = {1, 2}}

  / {{first, *rest} = {1, 2, 3, 4, 5}}

  / {{first, *middle, last} = {1, 2, 3, 4, 5}}

  === Type checking and coercion

  / String? s = 44  ;; this will throw an exception

  / {{String! a, Array! b} = {10, 10}}

  / {R"(\\d+).(\\d+)e([+\\-]?\\d+)"! {whole, int, frac, exp} = "10.7e9"}

  See also the section on [pattern matching]/?patterns.



patterns --> Pattern matching -->

  == Pattern matching

  A __pattern is an expression which can be "matched" against a
  value. Matching a pattern against a value can either _fail, in which
  case other patterns may be tried instead or an exception be thrown,
  or it can _succeed, in which case it may extract parts of the value
  and put them into variables or fields.

  Pattern matching therefore combines __verification that a value is
  structured as expected and __extraction of its parts into variables
  for further processing. The following table demonstrates EG's
  powerful pattern language:

  .note ..
    For demonstration purposes, most examples are of the form
    `{pattern = value}, which creates an object. Patterns can of
    course be found in other contexts, listed in the next section.

  .pattern_table ..
    + Pattern           + Example               + Meaning
    | `variable         | /{v = 123}            | Match anything, put in `variable
    | `literal          | /[10 = 5 + 5]         | Match the literal
    | `[== value]       | /[== [10 + 10] = 20]  | Equality test (other comparison operators also work)
    | `[p when pred] | /[x when x > 0 = 2] | Match if the predicate is true
    | `{p1, p2, ...}    | /{{a, b} = {1, 2}}    | Deconstruct/?deconstruction an array
    | `{field => p, ...} | /{{x => z} = {x = 69}} | Deconstruct/?deconstruction an object
    | `[type? p]  | /{String? s = .hello} | Check type or use a predicate/?predicates
    | `[func! p]  | /{Number! n = "666"} | Transform using a function or projector/?projectors
    | `[p1 and p2] | /{x and y = 88}   | Must match all patterns
    | `[p1 or p2]  | /[{1,x} or {x,1} = {5,1}, x] | Must match _one pattern, tried sequentially. All branches must contain the same variables.
    | [`else, `[_]] | /{{a, _} = {1, 2}} | Match anything, discard value

  === Where to use a pattern

  In general, everything to the left of the `[=] and `[->] operators
  is a pattern. Control structures such as /?match and /?each expect
  one or more __clauses of the form `[pattern -> body] in their
  body. For instance:

  /
    match 3:
       n when n < 1 -> "less than one"
       1 -> .one
       2 -> .two
       n -> "more than two"

  One of the most interesting features in EG is that lists of clauses
  can be nested easily by using the `match keyword _as a pattern:

  /
    calc{match} =
       Number? n -> n
       #add{calc! x, calc! y} -> x + y
       #sub{calc! x, calc! y} -> x - y
       #mul{calc! x, calc! y} -> x * y
       #div{calc! x, calc! match} ->
          0 -> throw E.division_by_zero{x}
          y -> x / y
       invalid ->
          throw E.invalid_operation{invalid}

    calc with #div{#add{10, #sub{4, 1}}, 2}

  If `match is found somewhere in a list of arguments, then the body
  must be a sequence of `[subpattern -> body]. `[calc! match], here,
  means that we first transform the value through the `calc function
  and we match the result of that against the two sub-clauses.


macros --> Macros -->

  == Macros

  __Macros permit the easy development of new language features. In
  EG, a macro receives a data structure containing an abstract
  representation the source code of its argument. It can execute
  arbitrary transformations on that code at compile time in order to
  generate new code to execute. In that sense EG's macro system is
  similar to that of Lisp, Scheme, Racket or Clojure. It is also
  hygienic/?hygiene.

  === A simple example

  The `unless macro is the opposite of `if: it executes its body when
  the condition is _not true. The definition is very straightforward:

  /
     macro unless{*, '{^test, ^body}}:
        'if{not ^test, ^body}

  Click on the definition to execute it. Then you can use it like
  this:

  / unless{0, "yes"}

  Or like this:

  / unless 0: "yes"

  Note that a macro normally takes four arguments, but it is often
  unnecessary to look at the first three. The `[*] in the arguments
  list is a nameless rest argument, so it's just a convenient way to
  discard the first three arguments.

  === The basics

  * The single quote (`[']) returns the [quoted form]/?quote of its
    argument, i.e. its abstract syntax. (Examples: /['x], /['{x, y}],
    /['[a + b]]).

  * The "quoted form" is really just an array.

  * In a quoted form, the caret (`[^]) "unquotes" its argument,
    inserting the result of the expression in the form. (Example:
    /['{1, 2, ^[#value{1 + 2}]}]).

  Use the quote\/unquote operators to extract the relevant parts of
  the macro's arguments and to construct the return value.

  === Further reading

  * See /?quote to read about the abstract representation of programs.

  * See /?macrointerface for the full interface available to macros.

  * See /?hygiene for how macros interact with scope and how a macro
    can define variables for users.


