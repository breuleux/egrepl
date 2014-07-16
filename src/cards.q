
blocks --> Blocks and indent -->

  === Blocks and indent

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
