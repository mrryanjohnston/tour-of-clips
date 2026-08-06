# Predicate Constraints

Predicate Constraints sound fancy, but they're pretty straight forward.
Basically they allow you to further specify what value a field holds. For
example, with our current knowledge, we can specify *exact* matches for values
such as `(name ?n&ryjo)`. Predicate Conditions allow us to perform a function on
the value to determine if it matches.

In our code example for this chapter, we write a basic Rule that describes a
rule that allows entry into a bar. In the United States of America, we require a
person to be 21 years of age or older. If they are under 21 years of age, they
are not allowed into a bar.

Note the familiar form of `?variable&`. We use the `and` symbol here (`&`) to
signify that `?variable` must match certain criteria. This allows us to read
this as "the age of a person and it is greater than or equal to 21" in the
`allow-entry-to-bar` Rule.

Also note that we make use of 2 different Facts in Working Memory to activate
our rules: the `name` and `age` Facts. Also note that in the LHS of our Rules,
we specify that the first field of these Facts must match by using `?person` in
both. Since `?person` is used in both of these conditions, we say that this Rule
is "activated" when these Facts have the same value in their first field.

For example, the `(name ryjo)` Fact and the `(age ryjo 32)` Fact will activate
the `allow-entry-to-bar` Rule together. Both the value in the first field match
for these Facts *and* the number 32 is greater than or equal to 21. The Facts
`(name ryjo)` and `(age someone 20)` will not activate the `no-entry-to-bar`
Rule. The number `20` is indeed less than 21, but these two Facts will not
activate the Rule together. However, the 2 Facts `(name someone)` and
`(age someone 20)` will. Not only is `20` less than `21` as noted in the
Predicate Condition `(>= ?a 21)`, but the Symbol `someone` matches in both
Facts.

```clips
(clear)

(defrule allow-entry-to-bar
  (name ?person)
  (age ?person ?a&:(>= ?a 21))
  =>
  (println ?person " is over 21 years old and can enter the bar!"))

(defrule no-entry-to-bar
  (name ?person)
  (age ?person ?a&:(< ?a 21))
  =>
  (println ?person " is not allowed in (under 21)."))

(assert
  (name ryjo) (age ryjo 32)
  (name someone) (age someone 20))

(run)
```

