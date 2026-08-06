# Prominently Salient

By using `(declare (salience` in our Rule, we can specify the "priority" of a
Rule. This allows us to declare that **some Rules must always run before
others**. We "hard-code" the execution order for our rules, and the Rete
algorithm builds around it.

Rules have a salience of `0` by default. Rules with a salience greater than `0`
will execute before them. Similarly, Rules with a lower salience will execute
after them. According to the
[Basic Programming Guide](https://clipsrules.net/documentation/v642/bpg642.pdf),
this feature should be used sparingly:

<blockquote cite="https://clipsrules.net/documentation/v642/bpg642.pdf">
<p>
Despite the large number of possible values, with good design there's rarely a need for more than
five salience values in a simple program and ten salience values in a complex program.
</p>
</blockquote>

For the most part, a Rules Engine should be order independent. This allows CLIPS
to do the "heavy lifting" of determining when Rules run. This is subtle, but
rather powerful. With Rules, you do not "pass" values into a "function" that
runs and returns a value. Instead, the algorithm "activates" Rules based on
"matched" Facts in Working Memory. This decouples the data stored in your system
(Facts) from the business logic (Rules).

This decoupling can help express the domain you're modeling with less references
to the "control flow" of the software. The more transparent the software, the
closer your system brings the user to the "truth" of your domain.

```clips
(clear)

(defrule third
  (declare (salience 0))
  ?f <- (my-fact)
  =>
  (println "Last!")
  (retract ?f))

(defrule never-runs
  (declare (salience -1))
  (my-fact)
  =>
  (println ":("))

(defrule first
  (declare (salience 2))
  (my-fact)
  =>
  (println "First!"))

(defrule second
  (declare (salience 1))
  (my-fact)
  =>
  (println "Second!"))

(assert (my-fact))

(run)
```

