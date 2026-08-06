# Clearly resetting

Let's talk about `(clear)` and `(reset)`. We're familiar with `(clear)` which
makes our environment like new again. No more Rules, no more Facts.

`(reset)` does a little less. It retracts all Facts in your system and Rule
activations while leaving the Rules themselves defined. In this way, you can use
`(reset)` to return your Engine to a known default "state" before running it
again with new input.

What happens if we need some Facts asserted to return to the "default" state?
Introducing `(deffacts`. When you use `(reset)`, the Facts defined in your
`(deffacts` will be asserted. Consider the example in this chapter and its
output. On the first run, we `(assert` 2 more fruit Facts than in the second. As
a result, we see two more people eat their favorite fruit.

```clips
(clear)

(deffacts fruits
  (fruit apple 1)
  (fruit banana 1)
  (fruit orange 1))

(deftemplate person
  (slot name)
  (slot favorite-fruit))

(deffacts people
  (person (name Tom) (favorite-fruit apple))
  (person (name Jenna) (favorite-fruit orange))
  (person (name Rian) (favorite-fruit apple)))

(defrule people-eat-favorite-fruits
  (person (name ?name) (favorite-fruit ?fruit))
  ?f <- (fruit ?fruit ?id)
  =>
  (println ?name " eats " ?fruit)
  (retract ?f))

(defrule persons-favorite-fruit-missing
  (person (name ?name) (favorite-fruit ?fruit))
  (not (fruit ?fruit ?))
  =>
  (format t "There's no more of %s's favorite fruit %s!%n" ?name ?fruit))

(reset)

(assert (fruit apple 2) (fruit orange 2))

(println "Run 1:")
(println "------")
(run)

(println " ")
(reset)

(println "Run 2:")
(println "------")
(run)
```

