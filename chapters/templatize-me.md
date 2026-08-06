# Templatize me

Templates are used to define a formal structure for Facts. By using
`(deftemplate person` in our example, we describe the structure of a `(person`
Fact. We wrote Facts as lists of values in previous Chapters. We would describe
these Facts as having ordered "fields." `(person Sally "Hi")` would describe a
`(person` Fact with the values `Sally` in its second field and `"Hi"` in its
third field.

With Templates, we are no longer bound to storing people's information in a
particular order. Instead, we store values in named "Slots." For example, we can
choose to define our Fact as `(person (greeting "Hi") (name Sally))`, greeting
first. We can also define "default" values for these named slots and omit them
in asserted Facts.

Using Templates gives us some flexibility in how we define our Facts as well as
how we write the matching patterns in the LHS of our Rules. Take a look at the
Rule `people-greet-each-other`. Our second pattern matches "a person whos name
is not `?name1`." We do not need to include a reference to this Fact's
`(greeting` Slot in this Rule, so we can omit it.

You'll also notice we define a default value for `(greeting` in the Template's
definition. There are many other ways to describe a Slot besides `default`. Take
a look at the
[Basic Programming Guide](https://clipsrules.net/documentation/v642/bpg642.pdf)
in the section titled "Deftemplate Construct" to learn what these are.

```clips
(clear)

(deftemplate person
  (slot name)
  (slot greeting (default Hello)))

(assert
  (person (name Greg))
  (person (name Sally) (greeting Hi))
  (person (name Sam) (greeting Howdy)))

(deffunction greet (?name1 ?name2 ?greeting)
  (println ?name1 " says \"" ?greeting "\" to " ?name2 "."))

(defrule people-greet-each-other
  (person (name ?name1) (greeting ?greeting1))
  (person (name ?name2&~?name1))
  =>
  (greet ?name1 ?name2 ?greeting1))

(run)
```

