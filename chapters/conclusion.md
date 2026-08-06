# ???

That's it for now! Thanks for sticking with the tutorial up to this point. I'll
be adding to this over time, so make sure to bookmark this page and check back
:).

All of the prose and code written in Chapters is authored by me. I used an LLM
to create the scripts that
[format the markdown files](https://github.com/mrryanjohnston/tour-of-clips/blob/main/wrap-md.awk)
and
[compile them into static HTML](https://github.com/mrryanjohnston/tour-of-clips/blob/main/build.sh).
I took a lot of inspiration from the [Tour of Go](https://go.dev/tour/welcome/1)
when creating this tutorial. I found it super helpful to not need to install
anything when learning Go years back. I used
[emscripten](https://emscripten.org/) to compile
[CLIPS](https://www.clipsrules.net/) into a WASM binary. I wrote the code editor
+ syntax highlighter with code snippets pulled from
[Stackoverflow](https://stackoverflow.com/). I'll admit I'm a bit proud of that
:).

My goal with this tutorial is to spread the word about CLIPS. I'd like to see it
used in more everyday applications because it's a very powerful way of
expressing complex business logic with less lines of code.

```clips
(clear)
(run)
```

