
{
   quaint["$"]{engine, match} =
      {{=> code} and engine! label} or {{=> code}, engine! label} ->
         .clickable %
            onclick{e} =
                e.preventDefault{}
                repl.process{code}
                repl.sink{}
            label
}



Help topics
===========

| $[help topics]    | List all help topics
| $[help variables] | Declaring and setting variables
| $[help blocks]    | Blocks and indent rules


Variables
=========

| __Declare a __[read-only] variable | $[let x = 1234]
| __Declare a __mutable variable     | $[var x = 1234]
| __Set a variable                   | $[x = 1234]

Attempting to set a variable that has not been declared will create a
__[read-only] variable in the local scope. (In other words, `let is
implicit)

.note ..
   As a convenience, all variables declared interactively in
   the top scope are in fact mutable.

You can create [help blocks]$blocks with their own local variables
using `[[]], `let or `where:

$ [[let a = 10, let b = 90, a = b]]
$ let [a = 10, b = 90]: a + b
$
  a + b where
     a = 10
     b = 90
