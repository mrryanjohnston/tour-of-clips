# So many words

The `(readline)` function will capture user input and return a string. If the
user's input has any spaces between words, we can use `(explode$` to break the
input up into a "multifield value." This lets us define patterns in our Rules
that will match on individual words entered by the user.

Take a look at the Rule `first-word-one`. This Rule will activate when the first
word entered by the user is "**one**." Similarly, the Rule `last-word-last` will
activate when the last word entered is "**last**."

The `anywhere` Rule will trigger if "**anywhere**" is entered anywhere in the
prompt. The `$?` will match for any number of words. For example, we see in the
`counter` Rule the pattern `(exploded-words $?words)`. This means "match any
number of values and reference them as a "multifield value" `?words`. Just like
`?`, `$?` allows us to say "match on any number of fields" without referencing
it in the RHS.

Speaking of the `counter` Rule: take a look at `(length$ ?words)`. As you may
have guessed, `(length$` will return the number of values in the multifield
value passed to it. In this case, it returns the number of words (as referenced
by `?words`) entered by the user in the prompt.

```clips
(clear)

(defrule get-words-from-user
  =>
  (assert (words (readline))))

(defrule catcher
  (words ?words)
  =>
  (println "You said: " ?words)
  (assert (exploded-words (explode$ ?words))))

(defrule counter
  (exploded-words $?words)
  =>
  (println "That's " (length$ ?words) " words total."))

(defrule silence
  (exploded-words)
  =>
  (println "Ah, the strong silent type..."))

(defrule first-word-one
  (exploded-words one $?words)
  =>
  (println "Your first word was 'one'"))

(defrule last-word-last
  (exploded-words $?words last)
  =>
  (println "Your last word was 'last'"))

(defrule anywhere
  (exploded-words $? anywhere $?)
  =>
  (println "At some point, you typed 'anywhere'"))

(run)
```

