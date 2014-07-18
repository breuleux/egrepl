
examples --> List of examples -->

  == Examples

  Click on an example's name to view and execute the code associated
  to it. If you want to edit the code, you can press `Up to recall it
  from history and `Enter or `[Shift-Enter] to resubmit.

  .note ..
    The `load macro loads a script asynchronously from an url and
    declares a global variable in the process. Once it is loaded,
    though, you can of course reuse the library without needing the
    `load block. In fact, ideally, you __shouldn't. See below.

  .warning ..
    If an example uses a `load statement, clicking on it more than
    once will load the library more than once. This can lead to funky
    results.

  === Libraries

  Plotting with `flot /
    loading "http://www.flotcharts.org/flot/jquery.flot.js" as $
    ===
    $out.elem.style.height = "500px" ;; making room
    $.plot{$out.elem, {p1, p2, p3}} where
       p1 = 1..100 each i -> {i, Math.sin{i / 10}}
       p2 = 1..100 each i -> {i, Math.sin{i / 10 - 1}}
       p3 = 1..100 each i -> {i, Math.sin{i / 10} + 0.25}
    undefined

  Plotting with `flot (old) /
    $out.elem.style.height = "500px" ;; making room
    load "http://www.flotcharts.org/flot/jquery.flot.js" as $:
       $.plot{$out.elem, {p1, p2, p3}} where
          p1 = 1..100 each i -> {i, Math.sin{i / 10}}
          p2 = 1..100 each i -> {i, Math.sin{i / 10 - 1}}
          p3 = 1..100 each i -> {i, Math.sin{i / 10} + 0.25}

  Google maps /
    ;; we need to give google a callback to execute after loading, so
    ;; we make mapinit a global variable (otherwise google can't see it!)
    globals: mapinit
    $out.elem.style.height = "500px" ;; important!
    mapinit{} =
       new google.maps.Map{$out.elem} with {
          zoom = 17
          center = new google.maps.LatLng{48.8582, 2.2945}
       }
    load "https://maps.googleapis.com/maps/api/js?v=3.exp&callback=mapinit" as google:
       pass

  Quaint editor using React /

    ;; This macro is sugar to create DOM elements (no need for JSX here!)
    macro [%%]{*, #data{#symbol{tag}, #multi! {*exprs}}}:
       props = #data{#symbol{"="}}
       children = {}
       exprs each match x ->
          '[^k = ^v] -> props.push{x}
          else -> children.push{x}
       'React.DOM[^=tag]{^props, ^*children}
    
    ;; This macro is sugar for React.createClass
    macro react{*, #data{v and #symbol{name}, #multi! {*exprs}}}:
       '[^v and React.DOM[^=name] = React.createClass{{^*exprs}}]

    $out.elem.style.height = "500px"
    load "http://fb.me/react-with-addons-0.11.0.js" as React:
       
       react Quaint:
          getInitialState{} =
             {text = this.props.initial}
          render{} =
             me = this
             div %%
                div %% [b %% .In]
                textarea %%
                   style = {height = "200px", width = "90%", padding = "10px"}
                   onChange{e} =
                      me.setState with {
                         text = me.refs.textarea.getDOMNode{}.value
                      }
                   ref = .textarea
                   defaultValue = this.state.text
                div %% [b %% .Out]
                div %%
                   style = {height = "200px", width = "90%"
                            border = "1px solid black", padding = "10px"
                            overflow = .auto}
                   dangerouslySetInnerHTML = {
                      __html = make_dom{Q this.state.text}.innerHTML
                   }

       React.renderComponent{Quaint %% [initial = ...], $out.elem} with
          "Quaint::http://breuleux.net/quaint is a _bit like Markdown, but not really."


  === Classics

  Fibonacci numbers /
     fib{match} =
        0 -> 0
        1 -> 1
        n -> fib{n - 1} + fib{n - 2}
     ===
     fib{30}
  [[imperative]] /
     fib{n} =
        var {a, b} = {0, 1}
        1..n each _ ->
           {a, b} = {b, a + b}
        a
     ===
     fib{30}
  span.separator ..
  Factorial numbers /   
     fact{match} =
        0 -> 1
        n -> n * fact{n - 1}
     ===
     fact{15}

  FizzBuzz /
    fizzbuzz{n} =
       1..n each
          i when i mod 15 == 0 -> "FizzBuzz"
          i when i mod 3 == 0 -> "Fizz"
          i when i mod 5 == 0 -> "Buzz"
          i -> i
    ===
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


  === Language features

  Point class /
     class Point:
        constructor{@x, @y} =
           pass
        distance{p} =
           [dx*dx + dy*dy] ** 0.5 where
              dx = @x - p.x
              dy = @y - p.y
     ===
     p1 = Point{100, 300}
     p2 = Point{400, 700}
     {p1, p2
      Point? p1, Point? {400, 700}
      p1.distance{p2}}


  === Cool tricks

  Local operator redefinition /
     10 + 90 where
        a + b = a - b


  === Macros

  Swap operator /
     macro [<=>]{*, #data{a, b}}:
        ;; EG enforces hygiene, so there cannot be a conflict
        ;; between the "temp" variable declared by the macro
        ;; and other existing variables with the same name
        '[let temp = ^a
          ^a = ^b
          ^b = temp]
     ===
     var {foo, bar} = {8, 88}
     foo <=> bar
     {foo, bar}
  span.separator ..
  Unless /
     macro unless{*, #data{test, body}}:
        'if{not ^test, ^body}
     ===
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
     ===
     add10 = ~[$ + 10]
     add10{91}
     ===
     first4 = ~$.substring{0, 4}
     first4{"hello"}

