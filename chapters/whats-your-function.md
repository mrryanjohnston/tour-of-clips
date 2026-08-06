# What's your function?

Functions allow you to reference chunks of code that you write repeatedly
throughout your program. If we were writing a book, we may find it easier to
"wrap" text that has been spoken in quotes as well as a reference to the
speaker. We do the same for shouting.

We can also store difficult-to-remember formulas as Functions. Personally, I
have trouble remembering the formula for converting fahrenheit to celsius. With
the help of `deffunction`, I can store this calculation and reference it easily.

Take note of the `(*`, `(-` and `(/` functions. These are basic math operations:
multiplication, subtraction and division. In CLIPS, we write the math problem
`1 + 2` as `(+ 1 2)`. That's because CLIPS uses a "LISP-like" syntax.

```clips
(clear)

(deffunction say (?words)
  (println "You say, \"" ?words ".\""))

(say "Hello, world")

(deffunction shout (?words)
  (println "\"" ?words "!\" you shout."))

(shout "Hello, world")'

(deffunction fahrenheit-to-celsius (?f)
  (* (- ?f 32) (/ 5 9) ))

(println "50°F is " (fahrenheit-to-celsius 50) "°C")
```

