# Who watches the statistics?

```clips
(clear)
(watch statistics)

(defrule fibonacci
  ?fact <- (fib ?fib ?lastfib ?i&:(> ?i 1))
  =>
  (print ?fib " ")
  (retract ?fact)
  (assert (fib (+ ?fib ?lastfib) ?fib (- ?i 1))))

(defrule last-fibonacci-number
  ?fact <- (fib ?fib ? 1)
  =>
  (println ?fib)
  (retract ?fact))

(assert (fib 1 0 10))

(run)
(unwatch statistics)
```

