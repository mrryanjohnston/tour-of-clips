# Rules: Activate!

```clips
(clear)
(watch activations)

(defrule b-exists-and-a-less-than-1
   (b ?b)
   (a ?a&:(< ?a 1))
   =>
   (println "there is b = " ?b ", AND a " ?a " is less than 1"))

(defrule a-less-than-1
   (a ?a&:(< ?a 1))
   =>
   (println "a " ?a " is less than 1"))

(println "  Step 1  ")
(println "==========")
(println "--- assert")
(assert (a 2))
(println "------ run")
(run)
(println " ")

(println "  Step 2  ")
(println "==========")
(println "--- assert")
(assert (a 0))
(println "------ run")
(run)
(println " ")

(println "  Step 3  ")
(println "==========")
(println "--- assert")
(assert (b foo) (a -1) (a 3))
(println "------ run")
(run)
(unwatch activations)
```

