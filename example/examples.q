
examples --> List of examples -->

  == Examples

  Click on an example's name to view and execute the code associated
  to it. If you want to edit the code, you can press `Up to recall it
  from history and `Enter or `[Ctrl-Enter] to resubmit.

  `[Shift-Click] an example to paste it in the REPL without executing
  it.

  === Libraries

  Plotting with `flot /
    load "http://www.flotcharts.org/flot/jquery.flot.js" as $
    ===
    $out.elem.style.height = "500px" ;; making room
    $.plot{$out.elem, {p1, p2, p3}} where
       p1 = 1..100 each i -> {i, Math.sin{i / 10}}
       p2 = 1..100 each i -> {i, Math.sin{i / 10 - 1}}
       p3 = 1..100 each i -> {i, Math.sin{i / 10} + 0.25}
    undefined

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
    load "https://maps.googleapis.com/maps/api/js?v=3.exp&callback=mapinit" as google

  Quaint editor using React /
    load "http://fb.me/react-with-addons-0.11.0.js" as React
    ===
    ;; This macro is sugar to create DOM elements (no need for JSX here!)
    macro [%%]{*, #data{#symbol{tag}, #multi! #multi{*exprs}}}:
       props = #data{#symbol{"="}}
       children = {}
       exprs each match x ->
          '[^k = ^v] -> props.push{x}
          else -> children.push{x}
       'React.DOM[^=tag]{^props, ^*children}
    
    ;; This macro is sugar for React.createClass
    macro react{*, #data{v and #symbol{name}, #multi! #multi{*exprs}}}:
       '[^v and React.DOM[^=name] = React.createClass{{^*exprs}}]
    ===
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
                   __html = DOM{Q this.state.text}.innerHTML
                }
    ===
    $out.elem.style.height = "500px"
    React.renderComponent{Quaint %% [initial = ...], $out.elem} with "
    __Quaint is the markup language used for the help topics in the left
    pane. It is a _bit like `Markdown.

    .note ..
      * You can [__ embed expressions]:
        6 * 6 = {6 * 6}

    + Title    + Comment
    | My table | I think it looks nice
    "
    undefined


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
  span.separator ..
  The "99 bottles of beer" song /
     bottle{match} =
        0 -> "no more bottles"
        1 -> "one bottle"
        n -> [String! n] + " bottles"
     
     action{match} =
        0 -> "Go to the store and buy some more,"
        n -> "Take one down and pass it around,"
     
     capitalize{s} =
        s[0].toUpperCase{} + s.substring{1}

     div %
        style = "height: 500px; overflow: auto"
        0..99 each i ->
           n = 99 - i
           p %
              capitalize{bottle{n}}, " of beer on the wall, ", bottle{n}, " of beer."
              br %
              action{n}, " ", bottle{[n + 99] mod 100}, " of beer on the wall."

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
  span.separator ..
  Multiplication table (HTML generation) /
     div %
        style % "table.mult td { width: 2em; text-align: right; }"
        h2 % "Multiplication table"
        table.mult %
           0..10 each i ->
              tr %
                 0..10 each j ->
                    td % i * j

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
     macro [~]{*, form, #data{#void{}, body}}:
        ;; We mark the $ variable to be resolved in the same
        ;; environment as the form (this must be done for any
        ;; variable introduced by a macro in order to make it
        ;; visible)
        dolla = form.env.mark{'$}
        '[{^dolla} -> ^body]
     ===
     add10 = ~[$ + 10]
     add10{91}
     ===
     first4 = ~$.substring{0, 4}
     first4{"hello"}

  === Miscellaneous

  Local operator redefinition /
     10 + 90 where
        a + b = a - b


react_example --> Wrapping React -->

  == An interface for React in Earl Grey

  .note ..
    Click on the code snippets in the order that they are given if you
    want them to work properly.

  React::http://facebook.github.io/react/ is a library to build user
  interfaces on the web. It is based on a virtual DOM. Let's load it:
  (click on the code to evaluate it!)

  / load "http://fb.me/react-with-addons-0.11.0.js" as React

  React comes with a language called JSX that lets you embed HTML
  templates in the code. We won't need it. Instead we will define an
  _[operator macro] to define virtual DOM nodes.

  === The `[%%] operator macro

  I have not yet decided on an API for custom precedence, but that
  doesn't matter too much. The default operator priority is tighter
  than assignment and comparison and logical operators and
  incomparable with arithmetic. We will use the `[%%] operator to
  create `React.DOM elements in a nice way.

  Abstractly speaking, we want this code:

  `[div %% [id = "x", "y", "z"]]

  to generate this code, which builds a virtual DOM node:

  `React.DOM["div"]{{id = "x"}, "y", "z"}.

  (Note that an indented block is equivalent to `[[...]]. See /?blocks)

  /
    macro [%%]{*, #data{#symbol{tag}, #multi! #multi{*exprs}}}:
       props = '{=}
       children = '{}
       exprs each match x ->
          '[^k = ^v] -> props.push{x}
          else -> children.push{x}
       'React.DOM[^=tag]{^props, *[^children]}

  I'll explain what all that gibberish does, but first let's see the
  fruit of our labor:

  /
    React.renderComponent{node, $out.elem} where
       node = em %% [strong %% "hello"]

  /
    React.renderComponent{node, $out.elem} where node =
       button %%
          onClick{e} = $out.log{.hello}
          "Say hello!"

  Seems nice. Now let's go over the macro code:

  * `[macro [%%]{*, ...}:] a macro is a function of four arguments,
    but we only use the last one here. The `[*] denotes an anonymous
    rest argument, which lets us ignore the first three arguments.

  * `[#data{lhs, rhs}] is an AST node. The first part will be the code
    for the left hand side of `[%%], and the second is the right hand
    side. I think the best way to understand is by example, using the
    /?quote operator. For instance, this is the AST of an expression:
    /['[span %% "hello"]] (you can click on the ...s to expand their
    contents).

  * `[#multi! #multi{*exprs}] is just a trick to normalize bodies. Look at
    /['x] and /['[x, y]], then look at /[#multi! 'x] and
    /[#multi! '[x, y]]. The latter representation is easier to manipulate
    because we are guaranteed to get a `[#multi] node.

  * `[props = '{=}] creates code for an empty object.

  * `[children = '{}] creates code for an empty array.

  * `[exprs each match x ->] iterates over each expression in the body
    on the right hand side of `[%%]. The expression is put in the
    variable `x, but we will also do pattern matching on it.

  * `['[^k = ^v] -> props.push{x}] will match any code that looks like
    `[foo = bar]. These are property definitions, so we push them into
    the empty object we created previously.

  * `[else -> children.push{x}]~: any other expression defines a child
    node.

  * Finally, `['React.DOM[^=tag]{^props, *[^children]}] builds the
    code that will replace the macro. `[^=tag] inserts a
    literal. `[^props] inserts the code we built for the properties
    object, and `[*[^children]] splices in the array of children we
    built.

  === The `react macro

  This one is simpler:

  /
    macro react{*, #data{v and #symbol{name}, #multi! #multi{*exprs}}}:
       '[^v and React.DOM[^=name] = React.createClass{{^*exprs}}]

  This maps

  `[react Banana: [render{} = ..., ...]]

  to:

  `[Banana and React.DOM["Banana"] = React.createClass{{render{} = ..., ...}}]

  Setting `React.DOM[name] is important because that is where `[%%]
  will look for it.

  The idiom `[x and y = z] is similar to `[x = y = z] in other
  languages.

  === Making a component

  Here is a simple counter component. It's also a great game (how many
  times can you click the button in an hour?):

  /
    react Counter:
       getInitialState{} =
          {count = this.props.initial}
       render{} =
          [@] = this
          div %%
             "Count = ", @state.count
             br %%
             button %%
                onClick{e} =
                   @setState with {count = @state.count + @props.increment}
                @props.label

  Let's test it!

  /
    React.renderComponent{node, $out.elem} where node =
       Counter %%
          initial = 0
          increment = 1
          label = strong %% "Add one"

  This is a pretty clean way to write and assemble components and we
  only needed nine lines of macro code to wrap the functionality we
  needed. A lot more could be done, for instance allowing CSS class or
  id in the left hand side of `[%%], but this is left as an exercise.

  For more information about writing macros:

  * See /?macros for a vague overview of macros.

  * See /?quote to read about the abstract representation of programs.

  * See /?macrointerface for the full interface available to macros.

  * See /?hygiene for how macros interact with scope and how a macro
    can define variables for users.
