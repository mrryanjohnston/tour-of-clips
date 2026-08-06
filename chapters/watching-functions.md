# Watching functions

```clips
(clear)
(watch deffunctions)

(deffunction less-than-1 (?a)
   (println "calculating whether " ?a " is less than 1...")
   (< ?a 1))

(defrule b-exists-and-a-less-than-1
   (b ?b)
   (a ?a&:(less-than-1 ?a))
   =>
   (println "there is b = " ?b ", AND a " ?a " is less than 1"))

(defrule a-less-than-1
   (a ?a&:(less-than-1 ?a))
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
(unwatch deffunctions)
```

