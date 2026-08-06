# Test Conditional

This example looks like the previous section. Instead of using `&:`, we define
our constraints using the `(test` Conditional Element.

The output for this example should look very similar to last example's.

```clips
(clear)

(defrule allow-entry-to-bar
  (name ?person)
  (age ?person ?a)
  (test (>= ?a 21))
  =>
  (println ?person " is over 21 years old and can enter the bar!"))

(defrule no-entry-to-bar
  (name ?person)
  (age ?person ?a)
  (test (< ?a 21))
  =>
  (println ?person " is not allowed in (under 21)."))

(assert
  (name ryjo) (age ryjo 32)
  (name someone) (age someone 20))

(run)
```

