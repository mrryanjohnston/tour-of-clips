# Do you read(line) me?

Sometime you want to take input from the user rather than "hard-code" their
name, age, and other details. We can take input from the user using
`(readline)`.

In this example, we take input from the user, then we tell them what they
entered. Note: when you run this example, a prompt will pop up on your screen.
Enter your text into the field, then click the "OK" button.

Similarly, `(read)` will take the input from a user, but it'll only take a
single word. Change `(readline)` to `(read)` in the code editor. If you enter
"foo bar 123" into the text box and then click the "OK" button, it'll only echo
out "foo."

```clips
(clear)

; replace (readline) with (read) and note the differences
(println "You entered: " (readline))

(run)
```

