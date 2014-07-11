
blocks --> Blocks and indent -->

  === Blocks and indent

  A __block is a sequence of statements or expressions. Blocks are
  defined using square brackets `[[]]. Variables defined inside a
  block are only valid in expressions within that block.

  `[[]] is also used for __grouping. It only creates a block when it
  encloses more than one expression, therefore `[[let x = 0]] and
  `[let x = 0] are completely equivalent with respect to scoping.

  An indented block is completely equivalent to wrapping it in
  `[[]]~s. For instance these two blocks are equivalent:

  one <-
    /
      if 1 > 0: [
         "I sure hope so!"
      ]

  two <-
    /
       if 1 > 0:
          "I sure hope so!"

  | {one} | {two}

  Note that line breaks are always equivalent to commas.


predicates --> Predicates (`[pred? x]) -->

  === Predicates

  The expression `[P? x] tests whether `x satisfies the __predicate
  `P. `[P? x] is equivalent to `P["::check"]{x}, which means that any
  object with a `[::check] method is technically a predicate. Here are
  a few examples from the base language:

  / String? .hello / Number? 1 / Array? .nope / R"x$"? .simplex / true? 123

  Predicates can also be used as patterns. As a pattern, a predicate
  matches a value if and only if that value satisfies the predicate:

  /
     match "apple banana cantaloupe":
        R"[^ ]{5,5}"? -> "there is a 5-letter word"
        else -> "there are no 5-letter words"

  Note that predicates do not modify or transform their arguments, but
  projectors/[help projectors] can.

  ==== Defining simple predicates

  You can easily create your own predicates with `[predicate!]

  /
     predicate! even{x} =
        x mod 2 == 0
     even? x = 2  ;; this will succeed
     even? x = 3  ;; but this will fail

  `[predicate!] wraps a function to define a `[::check] method. The
  function can still be called normally, e.g. /even{7}.

  ==== Default behavior

  If `P has no `[::check] method, `[P? x] verifies that `x is an
  instance of `P. In other words, it is by default equivalent to the
  JavaScript expression `[x instanceof P], although unlike JavaScript
  this behavior can be easily customized.


projectors --> Projectors (`[proj! x]) -->

  === Projectors

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


  ==== Defining a projector

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

