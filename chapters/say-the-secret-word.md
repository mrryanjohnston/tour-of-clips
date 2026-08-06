# Say the secret word

**Be warned:** note that there is a line commented out in this example. If you
uncomment this line, the pop-up prompt will continue to show until you enter the
word `secret`.

The reason that this loop occurs is because we `(retract` the `(word` Fact which
we captured as `?f` in the LHS of the `user-did-not-say-secret` Rule. This
triggers the pattern `(not (word ?))` in the `get-word-from-user` which is the
absence of a `(word` Fact with one field in Working Memory.

This example is a little more complex, but it provides a good example of a way
in which you can "validate" user input. This is not the *only* way, mind you. It
is, however, a good example of how the "main loop" of a program can be made
using only Rules and Facts.

```clips
(clear)

(defrule get-word-from-user
  ;uncommenting this line will cause a prompt to popup
  ;until you enter "secret" in the textbox ;)
  ;(not (word ?))
  =>
  (print "Enter your word: ")
  (bind ?word (read))
  (println ?word)
  (assert (word ?word)))

(defrule user-said-secret
  (word secret)
  =>
  (println "You said the secret word! Great job"))

(defrule user-did-not-say-secret
  ?f <- (word ~secret)
  =>
  (retract ?f)
  (println "Try again..."))

(run)
```

