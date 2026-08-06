# Capturing the Name

Let's combine two previously presented concepts; we'll both capture the value as
described in Chapter ["Running the Engine"](#running-the-engine) and defining a
pattern the value adhere to as presented in Chapter
["Negative, Ghostrider"](#negative-ghostrider). We'll do this by placing and `&`
between the variable used to capture the name `?n` and our pattern `~ryjo`. The
`&` symbol is known as a "Connective Constraint" and it means "and." We can read
the pattern `(name ?n&~ryjo)` as "a value and it is not ryjo."

Additionally, we `(assert)` three facts. Only two of them will "activate" the
`non-ryjos-only` rule we define right below it. Something neat to make note of:
we only need to call `(assert)` once in order to put three new Facts into
Working Memory.

We define a second rule `ryjo` here to demonstrate the "opposite" of the
`non-ryjos-only` rule. This will activate when a Fact enters Working Memory that
looks exactly like `(name ryjo)`.

Note how the Rules in this example don't execute in the order in which they were
written. The reason for this is **the order in which Rules are run is determined
algorithmically**. Read more about how CLIPS determines the order in which Rules
are run in section **5.2 Basic Cycle Of Rule Execution** of the
[Basic Programming Guide](https://clipsrules.net/documentation/v642/bpg642.pdf).
We can use `(salience` to explicitly declare the order in which Rules run. We'll
discuss this in Chapter ["Prominently Salient"](#prominently-salient).

```clips
(clear)

(assert
  (name Gabe)
  (name ryjo)
  (name John))

(defrule non-ryjos-only
  (name ?n&~ryjo)
  =>
  (println "Hello, " ?n "!"))

(defrule ryjo
  (name ryjo)
  =>
  (println "Oh hey there"))

(run)
```

