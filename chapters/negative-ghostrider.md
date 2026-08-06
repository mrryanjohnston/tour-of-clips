# Negative, Ghostrider

Sometimes you want to activate a Rule when there is a Fact in Working Memory
that does not match a certain pattern. The tilde (`~`) character is used to
negate a given pattern. It's like saying "a Fact that does not have this here."

Note that we did not capture the name in order to print it out in the RHS of
this Rule like we did in Chapter ["Running the Engine"](#running-the-engine).
We'll cover how to use these names in Chapter
["Capturing the Name"](#capturing-the-name).

First, we `(clear)` our environment of all previously defined Rules and Facts
from the CLIPS Environment. We then `(assert` two `(name`s: `Zach` and `Zethus`.
Finally, our Rule `non-ryjos-only` will "activate" when a Fact matching the
pattern `(name ~ryjo)` enters working memory. This pattern might be read in
English as "a Fact that starts with `name` and does not have `ryjo` in its
second field." Finally, the RHS of this Rule prints the text "Hello, not ryjo!"

**Bonus:** After you `(batch*)` this code, try navigating to Chapter
["Running the Engine"](#running-the-engine); you'll see that the previously
defined `greet` Rule runs for these two new names. That's because the examples
in this tutorial use the same CLIPS Environment. In this example, we use
`(clear)` at the top which removes everything defined in previous examples. You
will see this convention more in following chapters.

```clips
(clear)

(assert (name Zach) (name Zethus))

(defrule non-ryjos-only
  (name ~ryjo)
  =>
  (println "Hello, not ryjo!"))

(run)
```

