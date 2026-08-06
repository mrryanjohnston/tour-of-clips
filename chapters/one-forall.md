# One forall

Sometimes you want to know if all Facts in Working Memory match a given pattern.
`(forall` provides this check. In our example, `(forall` will match if every
`(name` Fact in working memory can be matched with an `(age` Fact (and vice
versa).

In our example, the Fact `(name another)` does not have an `(age` Fact with a
matching value `?n`. Therefore, our Engine tells us that the "Roster has been
declined."

```clips
(clear)

(assert
  (name ryjo) (age ryjo 32)
  (name someone) (age someone 20)
  (name another))

(defrule accept-roster
  (forall (name ?n) (age ?n ?))
  =>
  (println "Roster has been accepted"))

(defrule decline-roster
  (not (forall (name ?n) (age ?n ?)))
  =>
  (println "Roster has been declined"))

(run)
```

