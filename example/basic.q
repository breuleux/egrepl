

help --> Main help -->

  == The Earl Grey programming language

  [__ Earl Grey] is a new language that compiles to JavaScript. It's a
  bit of a mad cross of CoffeeScript (as a transpiler), Python (colons
  and significant indent) and Racket (pattern matching and macros).

  Why should you care? Good question!

  * A quirky, terse and highly consistent /?syntax inspired from Python
  * Advanced and deeply integrated [pattern matching]/?patterns
  * Arbitrary new features can be defined with /?macros
  * Can be used with existing JavaScript libraries and interact with
    the Node ecosystem
  * It is [written in itself]::https://github.com/breuleux/earl-grey/tree/master/src.
    The compiler can be run in the browser (as it is here)

  === The REPL

  To your right there is an [__ interactive interpreter] in which you
  can try out the language.

  | `Enter or `[Ctrl-Enter]             | Evaluate an expression
  | `[Shift-Enter]                      | Insert a new line
  | `[Up/Down] or `[Ctrl-Up/Ctrl-Down]  | Navigate history
  | `[Control-L]                        | Clear the screen

  [__ Click these boxes]/[1 + 1] to execute expressions in the
  interactive interpreter (`[Shift-click] to paste them without
  executing them).

  Type /help to display this page again if you lose it. You can also
  view the /?index (/help.index), and a selected list of /?topics
  (/help.topics).

  Or you can look at /?examples~!

  === Install

  ` npm install -g earlgrey

  This will install the `earl command. Run `earl with no arguments to
  start an interactive interpreter, or run an EG program as:

  ` earl run file.eg

  === Links

  * [Source code]::https://github.com/breuleux/earl-grey
  * IRC chat: `[#earlgrey] on FreeNode


topics --> Selected topics -->

  == Selected topics

  .note ..
    The /?index contains a list of all help topics.

  === Basic topics

  /? numbers / strings / variables / blocks / syntax / arrays / objects

  === Concepts

  /? patterns / deconstruction / predicates / projectors / errors

  === Features

  /? with / where / each

  === Macros

  /? macros / quote / hygiene

  === Examples

  /? examples



interface --> REPL interface (keyboard bindings etc.) -->

  == Keyboard controls

  | `[Up/Down]           | Navigate history
  | `[Ctrl-Enter]        | Evaluate an expression
  | `[Shift-Enter]       | Insert a new line
  | `[Control-l]         | Clear the screen

  `Enter will evaluate the current expression if the cursor is on the
  last line of input and the current indent level is zero or the
  previous line is blank.


brackets --> The semantics of brackets -->

  == The semantics of brackets in Earl Grey

  === A rant about conventions

  Bear with me here.

  The first thing a lot of people may notice with EG is that it breaks
  nearly universal conventions by using braces for calls and square
  brackets for blocks and grouping.

  This is not just to be different. The reason behind these unorthodox
  choices is that conventional bracket semantics __[lack
  consistency]. Adopting them requires syntax that is more complex
  than necessary. I mean, consider the following:

  * It makes no sense to use different brackets for array literals
    than for arrays of arguments. Both of them are, for all intents
    and purposes, the same data structure. Forget about convention:
    only think about _consistency: if `f(...)  calls `f on a list of
    arguments, `(...) should be an array literal. This makes the
    semantics of `(...) _[context-insensitive] and therefore simpler.

    Alas, this is _impossible using conventional syntax, because `()~s
    are used for lists of arguments and for grouping. These two roles
    are utterly inconsistent and therefore come at an inherent cost in
    syntactic simplicity.

  * Similarly, it makes no sense to use different brackets for
    grouping and for blocks. You can see this in C, Java and
    JavaScript where `{a; b; c} defines a block and executes
    statements in sequence and `(a, b, c) executes a sequence of
    expressions. Why are there two ways to do the same bloody thing?

  Basically, current conventions really look like they were drawn from
  a hat at random. People are used to them, and they are not _bad, but
  they are not _good.

  === What Earl Grey does

  The upshot of all this is that there are two fundamental roles for
  brackets:

  # __[Defining data structures]: arrays, hashes, lists of arguments.
  # __[Grouping expressions]: priority disambiguation, blocks.

  Now, part of what I wanted to do with EG is to simplify syntax as
  much as possible while preserving infix syntax and reducing
  structural noise (aka parentheses and brackets). Assigning one
  bracket type to role 1 and another to role 2 is clearly the simplest
  policy. Parentheses, unfortunately, conventionally fall in both
  categories, so assigning them one role but not the other would be
  confusing and a source of hard-to-track errors. It is easier to
  avoid using them wrong when it is always wrong to use them.

  Now, in JavaScript, there are two things you may want to do with a
  function: _call it (`f(x)), or _index it (`f[x] or `[f.x]). It appeared
  to me that the simplest way to handle these cases is that
  __[function calls are a special case of indexing], when the index is
  an array. It makes sense: you index with a string or a number, you
  call with a list of arguments. These are two different data types,
  so a generic "send" mechanism can simply dispatch on type to figure
  out whether it ought to index or call.

  This indicates `[[]] are the least disruptive brackets for grouping,
  because they preserve indexing syntax. Besides, provided that indent
  is the usual way to define blocks, it doesn't really matter which
  bracket type it translates to, so breaking that convention is not a
  big deal.

  All this shuffling around has two key advantages:

  # Brackets are _[context-insensitive]: they produce the same AST
    regardless of where they are located.

  # If function calls are a special case of indexing, you get
    application syntax for free: /[args = {"101", 2}, parseInt args]

  === Recovering the standard semantics for parentheses

  Regardless of consistency, conventional semantics for parentheses
  could be recovered with sugar, by mapping `f(expr) to `f{expr} and
  `(expr) to `[[expr]]. The REPL's editor actually does this on the
  fly when you type parentheses.

  I have nothing against such sugar in principle, since it would have
  no impact on the abstract syntax that is given to macros and the
  like. The reason why I did not do it is that the sugar may have a
  few counter-intuitive implications (for instance, a statement like
  `return(x + y) would return an array) and I want to test the "pure"
  version of the language first.

  Let me just say this: at first, EG's syntax felt wrong to me,
  despite having designed it myself. But I got used to it quickly and
  now it's everything else that feels wrong.


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
    Use /?match if there are many conditions to test.

    /
      match:
         when 1 == 0 -> false
         when 1 == 1 -> true
         when 1 == 2 -> false
         else -> false

  _syntax_longwhile <-
    /
      var i = 10
      while i > 0:
         $out.log{i}
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

  | __Comments         | / ;; this is a comment
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
  | /?match            | {_syntax_longmatch}
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

  Instead of escaping quotes, you can also write strings using
  `S[...]. Note that quotation marks and brackets in the string must
  be balanced.

  / S[Hello, my name is "Olivier"]


  A string can span multiple lines, whether with quotes or
  `S[...]. Line breaks, whitespace and indent is preserved verbatim.

  /
    "this is
     perfectly acceptable"

  /
    S[
      this,
      too!
    ]

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

  === Global variables

  The `globals statement can be used to declare variables as
  global. For instance, if you load jQuery as an external script and
  it defines the global variables `[$] and `jQuery, you need to tell
  EG about it as follows:

  /
    globals:
       $, jQuery

  If you don't, EG will consider both variables to be undeclared,
  which throws a syntax error.




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
    undefined where
       var i = 3
       intvl = setInterval{f, 1000} where f{} =
          match i:
             0 ->
                $out.log{"Blast off!"}
                clearInterval{intvl}
             n ->
                $out.log{i}
                i -= 1

  /
    [a*a + b*b] ** 0.5 where
       a = 3
       b = 4

  Note that the bindings for /f, /i, /intvl, /a and /b are only valid
  in the respective `where expressions. `where always lets you shadow
  existing variables and it even lets you shadow standard operators:

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


errors --> Error handling -->

  == Error handling

  The `throw and `try statements are used to throw exceptions and
  handle them, respectively. Furthermore, in order to make errors more
  unique, arbitrary new error "types" can be generated on the fly with
  the `E macro.

  / throw E.lemon{"so sour!"}

  Multiple tags can be given to an error. As is usual, the first
  argument is the message, but more arguments can be given:

  / throw E.food.lemon{"so sour!", {pH = 2}}

  The `try statement must contain a sequence of statements to execute
  and then a sequence of _clauses to catch an error if it
  happens. Clauses are tried in the order that they appear.

  /
    try:
       throw E.food.lemon{"so sour!", {pH = 2}}
       E.lemon? {arg} ->
          "a lemon error occurred with pH = " + String{arg.pH}
       E.food? e ->
          "a food error occurred"

  A generic clause can be used at the end to mop up any error. A
  `finally statement will be executed at the end regardless of whether
  an error occurs or not. If you think it looks better you can
  optionally wrap the statements to `try in a `do block (to be fair,
  you can _always wrap statements in a `do block):

  /
    try:
       do:
          null.x
       ReferenceError? e ->
          {"reference error" = e}
       TypeError? e ->
          {"type error" = e}
       e ->
          {"other error" = e}
       finally:
          $out.log with "This line will always be printed"



blocks --> Blocks and indent -->

  == Blocks and indent

  A __block is a sequence of statements or expressions. Blocks are
  defined using square brackets `[[]]. Variables defined inside a
  block are only valid in expressions within that block.

  `[[]] is also used for __grouping. It only creates a block when it
  encloses more than one expression, therefore /[[let x = 0]] and
  /[let x = 0] behave the same with respect to scoping, whereas
  /[[let x = 80, x]] only makes `x visible in the inner scope (the
  REPL strips the brackets, though, so you must test inside a
  function).

  An indented block is completely equivalent to wrapping it in
  `[[]]~s. For instance these two blocks are the same:

  one <-
    /
      if 1 < 0: [
         "Math is broken :("
      ]

  two <-
    /
       if 1 < 0:
         "Math is broken :("

  | {one} | {two}

  Line breaks are always equivalent to commas except for when the line
  that follows continuates it (denoted with a leading backslash).


match --> The `match control structure -->

  == `match

  `match does pattern matching of a value against one or more
  patterns. Several operators and control structures, such as `try or
  `each, contain implicit `match blocks.

  /
    calc{x} =
       match x:
          Number? n -> n
          #add{calc! x, calc! y} -> x + y
          #sub{calc! x, calc! y} -> x - y
          #mul{calc! x, calc! y} -> x * y
          #div{calc! x, calc! y} ->
             match y:
                0 -> throw E.division_by_zero{x}
                y -> x / y
          invalid ->
             throw E.invalid_operation{invalid}

    calc with #div{#add{10, #sub{4, 1}}, 2}

  Note that:

  /
    fact{x} =
       match x:
          1 -> 1
          n -> n * fact{n - 1}

  has the following shorthand:

  /
    fact{match} =
       1 -> 1
       n -> n * fact{n - 1}

  You can try to translate the `calc example to shorthand as an
  exercise.

  See the section on [pattern matching]/?patterns for more information
  about patterns.



