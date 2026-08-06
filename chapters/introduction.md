# Introduction

Over the last year and a half or so, I've been learning about the
[CLIPS](https://www.clipsrules.net/) programming language.
[A team of developers at NASA](https://clipsrules.net/AboutCLIPS.html) created
CLIPS in the mid-'80s. It was released into the public domain in the mid-'90s,
and it has been actively developed by one of the original team members
[Gary Riley](http://www.clipsrules.net/AboutTheDeveloper.html) ever since.

CLIPS has this air of mystery about it. There's no npm-like service that
centralizes common CLIPS "libraries." A lot of writing about the language
appears, on the surface, academic or higher-level. To top it off, the
[Rete algorithm](https://en.wikipedia.org/wiki/Rete_algorithm) central to CLIPS
can be rather intimidating to wrap one's head around.

Don't let these things deter you; CLIPS is well worth learning. Its Rules-based
approach is a good primer to learning neural networks and AI. With this
tutorial, you'll take your first steps into Rules Engines and Expert Systems.

First, we'll talk about why you should consider using CLIPS. At the heart of
CLIPS is the [Rete algorithm](https://en.wikipedia.org/wiki/Rete_algorithm).
This algorithm does a few very nice things for us. For one, it determines the
order in which Rules should run. This allows us to focus on **what the domain
business logic is** of our program rather than **how the software runs**.
Second, the Rete network "caches" common calculations our software will make.
Those who have written an in-app cache understand the benefits of this feature.

Another huge win for CLIPS is the excellent documentation and support provided
by the lead developer
[Gary Riley](http://www.clipsrules.net/AboutTheDeveloper.html). Take a look at
the various guides of all levels linked in the
[documentation section](https://clipsrules.net/#documentation) of the CLIPS
homepage. Also, Mr. Riley is very active in various forums providing support for
CLIPS. Once again, look at the main CLIPS website to find links to the
[various avenues of support](https://clipsrules.net/#support).

Finally, CLIPS is still actively developed; its latest release 6.4.2 was
published in January of 2025. Pretty incredible!

<h4>0.a This Tutorial</h4>

This tutorial is greatly inspired by the fantastic
[A Tour of Go](https://go.dev/tour/welcome/1). Run the examples presented in
this tutorial by clicking the `(batch*)` button under the code. The code in the
box is editable, so tweak the code to test your curiosity. The output from the
code will display in the box below the buttons. Navigate between the previous
and next Chapters by clicking the links at the bottom of the screen. The left
link (←) will navigate you to the previous chapter while the right link (→) will
advance to the next chapter. Between these two links will show the name of the
current Chapter. Click that link to reveal a list of all Chapters in this book.
Clicking one of these Chapters should navigate you to the appropriate Chapter.

```clips
; Welcome to the tutorial! This is known as a "comment."
; It is meant to help developers
; understand a particular line of code better.
;
; Click the (batch*) button to run this code sample.
; You will see CLIPS code written in this area of the webpage
; throughout this tour.
;
; This is a WASM compilation of CLIPS run completely in your browser;
; no server involved!
(println "Hello, world")
```

