# Just the Facts

In addition to Rules in CLIPS, we have "Facts." A Fact represents "data" in
CLIPS. In order to put data into CLIPS, we `(assert)`. Once we have `(assert)`ed
Facts, they are said to be "in working memory."

In the code to the right, we `(assert)` one `(name` Fact with `ryjo` in its
second field.

We then print a single line of text with our old friend `(println)`.

`(facts)` is a new one. We use this to print out the Facts stored in Working
Memory. In this case, we see 1 fact printed with an index `1` as denoted by
`f-1`.

Finally, we'll `(retract` this Fact that we just asserted. We can reference this
Fact with its index `1`.

Note: If you click `(batch*)` multiple times in a row, an error will appear.
This is because we must `(reset)` or `(clear)` the environment to reset the ids
assigned to Facts in Working Memory. If we do not, the Fact that we assert will
have an id of `2`, not `1`. If you click `(reset)` or `(clear)` and then click
`(batch*)` again, the code will behave as expected.

**Bonus**: if you are returning to this Chapter running the code in the Chapter
["Negative, Ghostrider"](#negative-ghostrider), you may see a few more than 1
Fact returned. That's because we do not `(clear)` at the top of the code to
first "clean up" the environment. You'll learn more about `(clear)` in Chapter
["Clearly Resetting"](#clearly-resetting).

```clips
(assert (name ryjo))
(println "The current facts: ")
(facts)
(retract 1)
(println "After retracting: ")
(facts)
```

