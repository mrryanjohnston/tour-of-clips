# Learning the Rules

Rules are an important part of understanding how CLIPS works. Rules consist of
an "antecedent" and a "consequent." The antecedent is also known as the "if
portion" or the "left-hand side." This part consists of the conditions that must
be satisfied for the Rule to run.

The consequent is also known as the "then portion" or the "right-hand side."
This part describes what will happen when the Rule is run.

These two pieces are separated by a `=&gt;`. The antecedent is before this
symbol while the consequent is after it.

In this example, we define a Rule called `will-run-no-matter-what`. This
particular Rule has nothing on the left-hand side so it will always run. The
right-hand side specifies that a `(println)` will run.

Finally after the Rule is defined, there is a `(run)`. In order for this to
work, click the `(batch*)` button.

```clips
(defrule will-run-no-matter-what
      =>
      (println "Hello from a rule, world!"))
(run)
```

