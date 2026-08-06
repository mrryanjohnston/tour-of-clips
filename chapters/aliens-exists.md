# Aliens exists

This is a bit of a longer example, but it showcases a few things combined
together. `(exists` will match once if a Fact in Working Memory matches the
pattern within. It will not run again while the condition continues to match. In
our example, we match for "any fact that starts with `(age` and is followed with
two values." When we use `?`, it doesn't matter what these values are; it only
matters that they are there at all.

Try modifying our `any-age-reported` Rule to capture the `?name` and
`(println ?name)` it in the RHS of the Rule.

We also use `(forall` to determine when every user has reported their age.

It may seem strange to give up control of our code's order of execution.
Remember, this lets us focus on our Business Logic rather than Control Flow of
our domain. Make sure to review the section **Performance Considerations** in
the
[Basic Programming Guide](https://clipsrules.net/documentation/v642/bpg642.pdf)
to learn how to write code in harmony with this approach.

```clips
(clear)

(defrule any-age-reported
  (exists (age ? ?))
  =>
  (println "Users have begun to report their age"))

(defrule no-ages-reported
  (not (age ? ?))
  =>
  (println "No user has reported their age yet..."))

(defrule reported-age
  (name ?n)
  (age ?n ?a)
  =>
  (format t "%s has reported their age: %d%n" ?n ?a))

(defrule has-not-reported-age
  (name ?n)
  (not (age ?n ?))
  =>
  (println ?n " has not yet reported their age"))

(defrule all-ages-reported
  (forall (name ?n) (age ?n ?))
  =>
  (println "Everyone in the system has reported their age"))

(assert
  (name ryjo)
  (name someone)
  (name another))

(println "First run results:")
(println "------------------")
(run)
(println " ")

(assert (age ryjo 32))

(println "Second run results:")
(println "-------------------")
(run)
(println " ")

(assert (age someone 20)
        (age another 52))

(println "Third run results:")
(println "------------------")
(run)
```

