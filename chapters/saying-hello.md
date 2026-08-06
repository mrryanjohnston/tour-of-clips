# Saying Hello

The classic "first program" is the "Hello, World" program. This will show you
how to output some text from your program. Click the `(batch*)` button under the
code on the right hand side. You should see text appear in the box beneath the
buttons.

With CLIPS, there are a few ways we can print text to the screen. Using
`(print)` will print words out, while `(println)` will print words out **with a
new line at the end**. In the code sample to the right, you can see us using
`(print)` to print the word "Hello". We then use `(println)` to print ", World!"
and a new line character. Things printed after this text will appear on the next
line.

`(printout t)` is like `(print)` and `(println)`, but it allows you to send text
to a given "router." In this case, we send the text to the router `t`, an alias
for `stdout`. This is the router that `(print)` and `(println)` send text to by
default. We also use the text `crlf` as the last argument to `(printout`. We do
this so that our text "breaks" at the end of the line; the next thing we print
will appear beneath this current line. `crlf` stands for "carriage return line
feed," which means "move the cursor to the beginning of the next line."

`(format t)` allows you to print a sentence structure that contains "format
flags." The `%s` and `%n` are format flags that specify a string and newline
respectively. The next argument (in this case "fun") will be substituted in
place of the `%s`. `%n` will be replaced with a new line character. To see more
of these "format flags," check out the
[Basic Programming Guide](https://clipsrules.net/documentation/v642/bpg642.pdf)
-- specifically the section entitled **12.4.6 Formatted Printing** -- to learn
more.

```clips
(print Hello)
(println ", World!")
(printout t "Welcome to this tour of CLIPS" crlf)
(format t "I hope that you have %s!%n" fun)
```

