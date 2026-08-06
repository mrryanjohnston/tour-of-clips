# And/Or

We can make use of "Connective Constraints" to better refine the LHS of our
Rules. For example, in the Rule `ors` in the code editor, we match on a Fact
whose second field matches either `Gabe` or `Peter`. This can be read as "A
`name` Fact whose first field we store the variable `?name` and matches either
`Gabe` or `Peter`."

In the `and-nots` Rule, we store the second field of a `name` Fact in the
variable `?name`. This time, we say "the value in the first field cannot match
`ryjo` and it cannot match `Zach` and it cannot match `Zethus`."

```clips
(clear)

(assert
  (name Gabe)
  (name ryjo)
  (name John)
  (name Zach)
  (name Zethus)
  (name Peter))

(defrule ors
  (name ?name&Gabe|Peter)
  =>
  (println "Greetings, " ?name))

(defrule and-nots
  (name ?name&~ryjo&~Zach&~Zethus)
  =>
  (println "Hi there, " ?name))

(run)
```

