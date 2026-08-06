# Running the Engine

The "Facts" stored in "Working Memory" can be used to satisfy the LHS (left-hand
side) of a rule. Remember: when the LHS of a Rule is satisfied, the Rule's RHS
(right-hand side) will run.

In the code to the right, we create a Rule using `(defrule)` called `greet`.
This Rule will "activate" when a Fact that matches the form `(name ?)` is
entered into Working Memory. Once we `(run)` the rules engine, the Right Hand
side of this Rule will run if a `name` Fact exists in the system with a second
field.

Next, we `(assert)` a `name` Fact with the value `ryjo` in its second field.
Once we do this, the `greet` rule is "activated;" when we `(run)` our Rules
Engine next, this Rule's RHS will be executed.

One thing to note: we can assert facts and define rules in whichever order we
want; we could assert the fact before defining the rule, and the rule would
still activate. Give it a try!

**Bonus**: if you are returning to this Chapter running the code in the Chapter
["Negative, Ghostrider"](#negative-ghostrider), you may see a few more than 1
Fact returned. That's because we do not `(clear)` at the top of the code to
first "clean up" the environment. You'll learn more about `(clear)` in Chapter
["Clearly Resetting"](#clearly-resetting).

```clips
(defrule greet
      (name ?name)
      =>
      (println "Hello " ?name "!"))
; Try moving this next line above the defrule
(assert (name ryjo))
(run)
```

