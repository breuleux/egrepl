
blocks ->

  === Blocks and indent

  A __block is a sequence of statements or expressions. Blocks are
  defined using square brackets `[[]]. Variables defined inside a
  block are only valid in expressions within that block.

  `[[]] is also used for __grouping. It only creates a block when it
  encloses more than one expression, therefore `[[let x = 0]] and
  `[let x = 0] are completely equivalent with respect to scoping.

  An indented block is completely equivalent to wrapping it in
  `[[]]~s. For instance these two blocks are equivalent:

  | [
  /
    if 1 > 0: [
       "I sure hope so!"
    ]
  ] | [
  /
     if 1 > 0:
        "I sure hope so!"
  ]

  Note that line breaks are always equivalent to commas.

