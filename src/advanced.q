

with2 --> The `with operator (detailed) -->

  == The `with operator (detailed)

  `with serves to create arrays, objects and to write function calls
  without using curly braces, or to pull elements of their definition
  outside of these braces. There are two use situations depending on
  whether there is an ellipsis (`[...]) or not.

  === Ellipsis

  If there is an __ellipsis (`[...]) on the left of `with, then the
  expression to the right will be inserted in place of the ellipsis.

  long <-
    /
      {...} with
         x = 1
         y = 2

  + `with expression            + Equivalent to:   + Notes
  | /[f{..., x} with y + z]     | /f{y + z, x}     |
  | /[[{x} -> ...] with x + x]  | /[{x} -> x + x]  | `[x + x] evaluates in the same scope as the ellipsis
  | /[[... * 2] with a + b]     | /[[a + b] * 2]   | The expression is inserted as a single unit, so the multiplication does not take priority
  | /[f{...} with [a, b]]       | /f{a, b}         | `[[...]] is spliced in
  | /[f{...} with {a, b}]       | /f{{a, b}}       | `{...} is _not spliced in
  | {long}                      | /{x = 1, y = 2}  | Indented blocks are equivalent to `[[]] blocks

  === No ellipsis

  Without an ellipsis, `with simply appends a new argument to the
  array, object or function call on the left (it creates them if
  needed):

  + `with expression   + Equivalent to:  + Notes
  | /[f{x} with y]     | /f{x, y}        |
  | /[f with x]        | /f{x}           |
  | /[{x} with y]      | /{x, y}         |
  | /[with x]          | /{x}            | Creates an array
  | /[with [x, y, z]]  | /{x, y, z}      | `[[...]] is spliced in
  | /[a + b with x]    | /[a + b{x}]     |
  | /[[a + b] with x]  | /[a + b]{x}     |

  .note ..
    `with has high priority on its left hand side, but low priority on
    its right hand side, so you may have to use `[[]]~s to wrap its
    argument on the left.




predicates --> Predicates (`[pred? x]) -->

  == Predicates

  The expression `[P? x] tests whether `x satisfies the __predicate
  `P. Here are a few examples from the base language:

  / String? .hello / Number? 1 / Array? .nope / R"x$"? .simplex / true? 123

  Predicates can also be used as patterns. As a pattern, a predicate
  matches a value if and only if that value satisfies the predicate:

  /
     match "apple banana cantaloupe":
        R"[^ ]{5,5}"? -> "there is a 5-letter word"
        else -> "there are no 5-letter words"

  Note that predicates do not modify or transform their arguments, but
  /?projectors can.

  === Defining a predicate

  To evaluate `[P? x] EG tries each of the following, in sequence:

  # `[P["::check"]{x}] (must return a boolean, if it exists).

  # `instanceof{x, P}: if `P has no `[::check] method, `[P? x]
    verifies that `x is an instance of `P.

  === Simple predicates

  You can create a predicate from a function with `[predicate!]

  /
     predicate! even{x} =
        x mod 2 == 0
     even? x = 2  ;; this will succeed
     even? x = 3  ;; but this will fail

  `[predicate!] wraps a function to define a `[::check] method. The
  function can still be called normally, e.g. /even{7}.



projectors --> Projectors (`[proj! x]) -->

  == Projectors

  If `P is a predicate or a type it is usual to define `[P! x] to
  transform `x so that `[P? [P! x]] is true. In other words, it
  "projects" `x to `P~'s value space:

  / String! {1, 2} / Number! "3.14" / Array! .yep

  This is not always the case. For instance, [/ R"(.)(.*)"! "abcd"]
  returns an array of matches.

  Projectors are especially useful in patterns. For instance we can
  directly translate the arguments of a function to strings:

  /
     concat{String! x, String! y} = x + y
     concat{123, 456}


  === Defining a projector

  To evaluate `[P! x] EG tries each of the following, in sequence:

  # `[P[":::project"]{x}] (_three colons) must return a tuple
    `{success, value}. If `success is false the match is considered to
    fail. It should never throw exceptions.

  # `[P["::project"]{x}] (_two colons) must either return a
    transformed value for `x or throw an exception (the exception
    means the match is a failure and will therefore be swallowed by
    the pattern matcher).

  # `P{x}. If `P has no projection methods it is simply called. This
    means any function is by default a projector:

    /
       double{x} = x + x
       double! x = 7
       x

    Unlike the previous case, exceptions thrown by function projectors
    are not swallowed by the pattern matcher.


quaint --> Quaint markup -->

  == Quaint markup language

  Quaint::http://breuleux.net/quaint is the markup language used to
  define this document. It is Markdown-ish, but it is more consistent
  and easier to extend. It's crude and incomplete but still fun to
  play with.

  /
    Q"
    == Header

    This is _emphasis, __[strong emphasis], `verbatim, a
    link::http://google.com to a seach engine.

    * Bullet points!
    * [_ whitespace matters].
      Group by indent.
    * 6 * 6 = {6 * 6}
    * Link to this page: /?quaint

    + Title    + Comment
    | My table | I think it looks nice
    "


quote --> Abstract syntax -->

  == Abstract syntax

  EG's abstract syntax is a nested array structure. Each node of the
  structure is of the form `{type, arg1, arg2, ...} and may also hold
  a `location field.

  The abstract syntax of any expression can be extracted with the
  quote operator, `[']. For the rest of the page, remember the
  following sugar: /[#xyz{1, 2} == {"xyz", 1, 2}].

  === Node types

  There are only six fundamental node types which can be output by the
  parser:

  + Node type  + Meaning        + Example
  | `[#symbol] | Variable name  | /['a == #symbol{.a}]
  | `[#value]  | Literal        | /['"xyz" == #value{"xyz"}]
  | `[#data]   | Data structure | /['{1, 2} == #data{#value{1}, #value{2}}]
  | `[#multi]  | Block          | /['[1, 2] == #multi{#value{1}, #value{2}}]
  |            |                | __But: /['[1] == #value{1}] (`[#multi] is never produced with a single argument)
  | `[#send]   | Application    | /['[a b] == #send{#symbol{.a}, #symbol{.b}}]
  |            |                | /['a{b} == #send{#symbol{.a}, #data{#symbol{.b}}}]
  |            |                | /['[1 + 2] == #send{#symbol{"+"}, #data{#value{1}, #value{2}}}]
  | `[#void]   | Absence        | /['[+1] == #send{#symbol{"+"}, #data{#void{}, #value{1}}}]
  |            |                | /['[1+] == #send{#symbol{"+"}, #data{#value{1}, #void{}}}]

  Here are some interesting examples and edge cases:

  / '[+] / '[[[xyz]]] / '{} / '[] / '{a,,b} / '[.abc]

  / ['[a: b] == 'a{b}] / ['[a b: c] == 'a{b, c}] / ['[a{b} with c] == 'a{b, c}]

  / ['[a @@ b] == '[@@]{a, b}] / ['[a b] == 'a[b]]

  As you can see in some of these examples, EG discards some
  information during parsing:

  * `[[]] blocks are erased from the parse tree when they only have
    one child

  * The operator application `[a op b] has a completely equivalent
    normal form, `[op]{a, b}

  * Both `[:] and /with simplify the AST _before macro processing

  These rules create useful invariants, so that the user may format
  the same expression in various ways, while macro writers can focus
  on a single canonical form.




macrointerface --> Macro API -->

  == Macro API

  .note ..
    The interface is not final.

  A macro takes four arguments:

  * __[`context]: a data structure that describes the kind of
    expression in which the macro is found: is it found in a normal
    expression? Inside `{...}~s? Or was it found somewhere a pattern
    or a clause is expected? A context can be seen as a kind of
    extension point: if one writes a macro that produces regular
    expressions, one could define a "regular expression"
    context. Other macros written by other people can then check for
    that context to know that they should produce a regular
    expression.

  * __[`scope] represents the lexical scope in which the macro is
    located. Given this scope, one can resolve the current binding of
    any variable within a given environment (depending on the value of
    `context, the set of bindings may not yet be complete).

  * __[`form] is the complete expression that the macro's result will
    be replacing.

  * __[`argument] is the macro's argument. Typically one can extract
    it from `form, but not always, and it is more practical to match
    it directly. In particular `argument will be `[#void{}] if the
    macro has no argument at all (for instance, in the code `[[mac]],
    `mac has no argument). This is useful to write macros that look
    and act like normal variables.

  More details will be added soon.


hygiene --> Hygienic macros -->

  == Macros and hygiene

  __Hygiene is an important property of macro systems: the goal is to
  keep macros well-behaved by making sure that the variables defined
  in user code do not leak into macro-generated code, and vice
  versa. For instance, a macro generating an `if statement ought not
  to stop working if, for some reason, the user rebinds the `if
  variable.

  EG tags every node output by the parser with an `env field. Two
  symbols refer to the same variable if and only if looking up their
  names in their respective environments in their respective scopes
  yields the same reference for both. By default, code constructed
  using /?quote has no `env, but when it is returned to the macro
  expander, untagged nodes are tagged with a fresh environment that
  looks up bindings at the definition site. This protects the user's
  bindings from interfering with the macro's, and vice versa.

  By extracting the environment of its form or argument and tagging
  generated code snippets with it, a macro can "violate" hygiene. This
  lets it intentionally define variables for use inside the
  macro. This is typically done with the `env.mark method. Here is an
  example:

  === Capturing names

  /
     macro func{*, form, body}:
        ;; Create a function with a single argument named $
        dolla = form.env.mark{'$}
        '[{^dolla} -> ^body]

     add10 = func $ + 10
     first4 = func $.substring{0, 4}

     {add10{91}, first4{"hello"}}

  What we want to do is simple: we want to let the body of `func refer
  to its argument with `[$]. If we did this naively, e.g. by returning
  `['[{$} -> ^body]], it would not work, because EG will think that the
  argument named `[$] and the occurrences of `[$] in the body refer to
  _[different variables]. This is usually a good thing, but now we
  want to defeat it.

  First we know that `form.env is the environment in which the call to
  the `func statement was made (it could be user code, or it could be
  another macro). `form.env.mark{'$} will therefore "mark" a `[$]
  symbol as belonging to that same environment, and we save that
  marked symbol in the `dolla variable. All we have to do, then, is to
  use this marked variable to declare the argument.

  .note ..
    You can also get an `env from `body or any other node. This will
    only make a difference if they come from different environments,
    for instance if another macro returned `['[func ^x]]. __[It is
    usually safest] to use [`form]'s environment because it refers to
    the macro call itself, so unintended interference is rather
    unlikely.





