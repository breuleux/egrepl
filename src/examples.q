
examples --> List of examples -->

  === Examples

  Click on an example's name to view and execute the code associated
  to it. If you want to edit the code, you can press `Up to recall it
  from history and `Enter or `[Shift-Enter] to resubmit.


  ==== Classics

  Fibonacci numbers /
     fib{match} =
        0 -> 0
        1 -> 1
        n -> fib{n - 1} + fib{n - 2}

     fib{30}
  [[imperative]] /
     fib{n} =
        var {a, b} = {0, 1}
        1..n each _ ->
           {a, b} = {b, a + b}
        a

     fib{30}
  span.separator ..
  Factorial numbers /   
     fact{match} =
        0 -> 1
        n -> n * fact{n - 1}

     fact{15}

  FizzBuzz /
    fizzbuzz{n} =
       1..n each
          i when i mod 15 == 0 -> "FizzBuzz"
          i when i mod 3 == 0 -> "Fizz"
          i when i mod 5 == 0 -> "Buzz"
          i -> i

    fizzbuzz{100}

  The "99 bottles of beer" song (long output) /
     bottle{match} =
        0 -> "no more bottles"
        1 -> "one bottle"
        n -> [String! n] + " bottles"
     
     action{match} =
        0 -> "Go to the store and buy some more,"
        n -> "Take one down and pass it around,"
     
     capitalize{s} =
        s[0].toUpperCase{} + s.substring{1}
     
     lines = {}
     0..99 each i ->
        n = 99 - i
        lines.push with
           capitalize{bottle{n}} + " of beer on the wall, " + bottle{n} + " of beer."
           action{n} + " " + bottle{[n + 99] mod 100} + " of beer on the wall."
           ""
     lines.join{"\n"}


  ==== Language features

  Point class /
     class Point:
        constructor{@x, @y} =
           pass
        distance{p} =
           [dx*dx + dy*dy] ** 0.5 where
              dx = @x - p.x
              dy = @y - p.y

     p1 = Point{100, 300}
     p2 = Point{400, 700}
     {p1, p2
      Point? p1, Point? {400, 700}
      p1.distance{p2}}


  ==== Cool tricks

  Local operator redefinition /
     10 + 90 where
        a + b = a - b


  ==== Macros

  Swap operator /
     macro [<=>]{*, #data{a, b}}:
        ;; EG enforces hygiene, so there cannot be a conflict
        ;; between the "temp" variable declared by the macro
        ;; and other existing variables with the same name
        '[let temp = ^a
          ^a = ^b
          ^b = temp]

     var {foo, bar} = {8, 88}
     foo <=> bar
     {foo, bar}
  span.separator ..
  Unless /
     macro unless{*, #data{test, body}}:
        'if{not ^test, ^body}

     unless 0:
        "yes"
  span.separator ..
  Anonymous function /
     macro [~]{*, #data{#void{}, body}}:
        ;; We mark the $ variable to be resolved in the same
        ;; environment as the body (this must be done for any
        ;; variable introduced by a macro in order to make it
        ;; visible)
        dolla = body.env.mark{'$}
        '[{^dolla} -> ^body]

     add10 = ~[$ + 10]
     first4 = ~$.substring{0, 4}

     {add10{91}, first4{"hello"}}

