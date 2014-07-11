
tut0 -->

  === Keyboard controls

  | `[Up/Down]           | Navigate history
  | `[Enter/Shift-Enter] | Evaluate an expression
  | `[Control-l]         | Clear the screen
  | `[Control-m]         | Toggle multiline mode

  Type /next to continue with the tutorial.



tut1 -->

  === Basics

  Click on boxes like /this to evaluate their contents.

  ==== Strings

  / "hello world" / [.word] / "My name is \"Olivier\""

  ==== Numbers

  | __Decimal       | / 1 / 1.4 / 4.93e51
  | __Hex           | / 16rFF / 16r100 / 16rDEADBEEF / 16r0.8
  | __[Binary etc.] | / 2r1110 / 3r20 / 36rZAZZ

  ==== Function calls

  | __Call    | / alert{"Hello!"} / alert with "Hello!"
  | __Methods | [/ "hello".substring{1}]

  /next => variables


tut2 -->

  === Variables

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

  /
    a + b where
       a = 10
       b = 90

  Be are that `[[]] only creates a block when it encloses more than
  one expression. An indented block is completely equivalent to
  wrapping it in `[[]]~s.

  /next => data structures


tut3 -->

  === Data structures

  Earl Grey uses curly braces `{} to define all data structures.

  | __Arrays  | / {1, 2, 3} / {1, {2, 3}} / {"hello"}
  | __Objects | / {name = .Peter, age = 20} / {"a" => 123}

  The empty array is `{} and the empty object is `{=}.

  ==== Deconstruction

  You can extract array elements and object fields into variables
  directly:

  / {x, y} = {11, 22}

  / {x, *rest, y} = {111, 222, 333, 444}

  / {=> name} = {name = .Peter, age = 20}

  ==== Operations

  | __Concatenation   | / {1, 2} ++ {3, 4, 5}
  | __[Merge objects] | / {name = .Kim} & {age = 39}

  /next => control structures


tut4 -->

  === Control structures

  `if and `while are available:

  /
    if 13 > 0:
       then: "This number is positive!"
       else: "This number is negative!"

  /
    i = 3
    while i > 0:
       alert{i}
    i--

  Notice that both branches of `if must be nested. The expression form
  of `if is simply /if{1, .yes, .no}.

  /next => control structures \[2\]


tut5 -->

  === Control structures \[2\]

  Earl Grey's `if nests poorly, so if you want to write many clauses
  use `match.

  /
    x = 13
    match:
       when x > 0 -> .positive
       when x < 0 -> .negative
       when x == 0 -> .zero

  You can also match on the variable directly!

  /
    x = 13
    match x:
       > 0 -> .positive
       < 0 -> .negative
       0 -> .zero

  The left hand side of the arrow is a special pattern matching
  language, whereas `when takes a standard expression."

  /next => each


tut6 -->

  === `each

  A single operator serves both looping over data structures and list
  comprehensions.

  / {1, 2, 3} each i -> i * i

  / 1..10 each i -> i * i

  / 1..10 each i when i mod 2 == 0 -> i

  You can have more than one clause.

  /
    {1, 2, .hello, 4, 72, 99, {}} each
        String? s -> {s, .string}
        Number? i when i mod 2 == 0 -> {i, .even}
        Number? i when i mod 2 == 1 -> {i, .odd}
        x -> {x, .dunno}

  `first and `last are special patterns.

  /
    acc = ""
    {.a, .b, .c, .d} each
       first x -> acc += "<" + x
       last x -> acc += "; " + x + ">"
       x -> acc += "; " + x
    acc

  /next => functions


tut7 -->

  === Functions

  Functions are declared with `[=] or `[->]. For instance, the
  following are equivalent:

  / f{x, y} = [x * x + y * y] ** 0.5

  / f = {x, y} -> [x * x + y * y] ** 0.5

  It works inside object definitions as well, of course

  / {add1{x} = x + 1, add2{x} = x + 2}

  Pattern matching is deeply integrated in Earl Grey. "For instance:"

  /
    fact{match} =
       0 or 1 -> 1
       n -> n * fact{n - 1}

  /next => type checking and coercion


tut8 -->

  === Type checking and coercion

  | __[Type checking] | / String? .hello / Number? 1 / Array? .nope / R"x$"? .simplex
  | __Coercion        | / String! {1, 2} / Number! "3.14" / Array! .yep

  Both type checking and coercion can be used in patterns. Observe the
  difference in behavior of the following functions:

  / f{1, "2"} where f{x, y} = x + y

  / f{1, "2"} where f{Number? x, Number? y} = x + y

  / f{1, "2"} where f{Number! x, Number! y} = x + y

  Functions naturally act as coercers:

  / parseInt! x = "99"

  ==== Predicates

  You can create your own predicates with the `predicate builtin.

  /
     predicate! even{x} = x mod 2 == 0
     even? x = 2  ;; this will succeed
     even? x = 3  ;; but this will fail

  /next => classes


tut9 -->

  === Classes

  Classes are declared with the `class macro. As a convenience, `[@]
  can be used to refer to fields and members of the instance.

  /
    class Person:
       constructor{name, age, job} =
          @name = name
          @age = age
          @job = job
       hello{} =
          "Hello, I am " + @name + ", " + @age + ", and I am a " + @job

  The `new keyword is optional. I prefer to avoid it.

  / Person{.Sonia, 25, .baker}

  / Person{.Jack, 56, "serial murderer"}.hello{}

  /next => HTML generation


tut10 -->

  === Here, let's have some fun

  The `[%] operator creates structured data which is directly
  translated as HTML by this evaluation environment. Try these:

  / [b % .hello] / [i % .world]

  We can print out a multiplication table!

  /
    table % 1..10 each i ->
       tr % 1..10 each j ->
          td % i * j

  /next => the end


tut11 -->

  === The end

  This is the end of this humble tutorial, but you can keep messing
  around with the language, it's a lot of fun :\)


