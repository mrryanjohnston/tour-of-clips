# COOL!

CLIPS has an Object Oriented Language built-in to it called COOL. It's an
awesome name for a really convenient set of functionality.

Instead of `deftemplate`s, you use `defclass`es. Instead of `assert`, you use
`make-instance of`. Instances are kind-of like facts but with inheritance. You
can still match in the LHF of Rules just like with Facts.

Additionally, Instances can have a name which you can use to look up instances
directly.

```clips
(clear)
(defclass FOO (is-a USER)
  (slot bar))
(defclass BAZ (is-a FOO)
  (slot bat))
(defrule foo
  (object (is-a FOO) (bar ?bar))
  =>
  (println "Bar: " ?bar))
(make-instance of FOO (bar "My bar!"))
(make-instance [ryjo] of BAZ (bar "Another one :)"))
(run)
```

