#!/bin/sh
# Generate tour-of-clips.html from template/ + chapters/ in the order given by
# chapters-index. Each chapters/<slug>.md holds one chapter (title, prose, and a
# ```clips code sample); section numbering and the bottom-nav are derived here.
set -eu                 # abort on any error (-e) or use of an unset variable (-u)
cd "$(dirname "$0")"    # run from the script's own dir so relative paths resolve

cat template/head.html  # emit the static top of the page (head, header, opening divs)
awk '
# trim(): strip leading and trailing whitespace from a string and return it.
function trim(s){ sub(/^[ \t]+/,"",s); sub(/[ \t]+$/,"",s); return s }

# --- inline markdown -> html, applied only OUTSIDE `code` spans ---------------
# md_bold(): turn **bold** into <b>bold</b>. Splitting on the literal "**" makes
# every even-indexed piece the text that sat between a pair of markers.
function md_bold(s,   a,i,n,o){ n=split(s,a,"\\*\\*"); o=a[1]   # o starts as the text before the first **
  for(i=2;i<=n;i++){ o=o ((i%2==0)?"<b>" a[i] "</b>":a[i]) }    # even piece = inside a pair -> wrap in <b>
  return o }                                                    # rebuilt string with bold applied
# md_italic(): same idea as md_bold but for single-*asterisk* -> <i>italic</i>.
function md_italic(s,   a,i,n,o){ n=split(s,a,"\\*"); o=a[1]     # split on a single literal "*"
  for(i=2;i<=n;i++){ o=o ((i%2==0)?"<i>" a[i] "</i>":a[i]) }     # even piece = between a pair -> wrap in <i>
  return o }                                                    # rebuilt string with italics applied
# md_link(): turn [text](url) into an <a> tag; internal #anchors get no target,
# external URLs open in a new tab (target="_blank").
function md_link(s,   o,rest,m,txt,url){ o=""; rest=s                          # o = result so far, rest = unscanned tail
  while(match(rest,/\[[^]]*\]\([^)]*\)/)){                                     # find the next [..](..) in the tail
    o=o substr(rest,1,RSTART-1); m=substr(rest,RSTART,RLENGTH); rest=substr(rest,RSTART+RLENGTH)  # keep text before it; m=the match; advance rest past it
    txt=m; sub(/^\[/,"",txt); sub(/\].*/,"",txt)                              # txt = the label between [ and ]
    url=m; sub(/^[^(]*\(/,"",url); sub(/\)$/,"",url)                          # url = the target between ( and )
    o=o "<a href=\"" url "\"" ((url ~ /^#/)?"":" target=\"_blank\"") ">" txt "</a>"  # append the <a>, target only for non-#
  }
  return o rest }                                                             # result plus whatever text followed the last link
# inline(): apply all inline conversions, but ONLY to text outside `code` spans.
# Splitting on the backtick makes odd pieces "outside code" and even pieces the
# literal code content (kept verbatim so e.g. the * in (batch*) is never italic).
function inline(s,   n,seg,i,o){ n=split(s,seg,"`"); o=""                                    # seg[] = alternating outside/inside-code chunks
  for(i=1;i<=n;i++){ o=o ((i%2==1)? md_italic(md_bold(md_link(seg[i]))) : "<code>" seg[i] "</code>") }  # odd=convert links/bold/italic, even=wrap as <code>
  return o }                                                                                 # fully inlined html

# Greedy word-wrap to ~width columns of body text (indent added per line).
# Breaks only at spaces that are outside an HTML tag, so tags stay intact; an
# unbreakable chunk longer than width overflows (soft "when possible" limit).
function htmlwrap(s,indent,width,   out,line,tok,i,n,ch,tag){
  n=length(s); out=""; line=""; tok=""; tag=0    # line=current output line, tok=current word, tag=1 while inside <...>
  for(i=1;i<=n;i++){ ch=substr(s,i,1)            # walk the string one character at a time
    if(ch=="<") tag=1; else if(ch==">") tag=0    # track whether we are inside an HTML tag
    if(ch==" " && !tag){                         # a space outside a tag is a candidate line break
      if(tok!=""){                               # only act when a word has been collected
        if(line=="") line=tok                    # first word of the line: just place it
        else if(length(line)+1+length(tok)<=width) line=line " " tok  # fits -> append to current line
        else { out=out indent line "\n"; line=tok }                   # too wide -> flush line, word starts next line
        tok=""                                   # word consumed; start collecting the next one
      }
    } else tok=tok ch                            # any non-breaking char (incl. spaces inside a tag) extends the word
  }
  if(tok!=""){ if(line=="") line=tok                                       # flush the final trailing word:
               else if(length(line)+1+length(tok)<=width) line=line " " tok  #   append if it fits
               else { out=out indent line "\n"; line=tok } }                 #   else put it on its own line
  if(line!="") out=out indent line "\n"          # emit the last pending line
  return out                                     # wrapped, indented block (ends in newline)
}

# --- block emitters -----------------------------------------------------------
# flush(): emit the buffered block (buf[1..nbuf]) as either a raw-html passthrough
# or a wrapped <p> paragraph, then reset the buffer.
function flush(   i,txt){
  if(nbuf==0) return                             # nothing buffered -> nothing to do
  if(buf[1] ~ /^[ \t]*</){                    # raw html block (e.g. <h4>, <blockquote>)
    for(i=1;i<=nbuf;i++) print "          " buf[i]  # print each raw line verbatim at 10-space indent
  } else {                                     # prose paragraph, wrapped to ~80 cols
    txt=buf[1]; for(i=2;i<=nbuf;i++) txt=txt " " buf[i]  # join the buffered lines into one logical paragraph
    print "          <p>"                        # open the paragraph
    printf "%s", htmlwrap(inline(txt), "          ", 70)  # inline-convert, then wrap to 70 cols + 10 indent (~80 total)
    print "          </p>"                       # close the paragraph
  }
  nbuf=0                                         # reset the buffer for the next block
}
# emit_code(): render a collected ```clips block as the interactive <pre>. The
# </pre> is glued to the last code line so no blank line renders at the bottom.
function emit_code(id,   c){ c=codebuf; sub(/\n$/,"",c)                        # copy code, drop its single trailing newline
  print "          <pre id=\"input-" id "\" class=\"documentation-input\">"    # opening tag (id ties it to the slug of this section)
  print c "</pre>" }                                                          # code verbatim, then the closing tag

# render(): emit one full <section> for chapter index i. The section id is the
# chapter slug (stable across reordering); its position rides along in
# data-index so old #<number> links can still be resolved to it.
function render(i,   f,line){
  f="chapters/" slug[i] ".md"                    # path to this chapter markdown source
  print "        <section id=\"" slug[i] "\" data-index=\"" i "\">"  # open the section (id = stable slug, data-index = position)
  print "          <h3>" i ". " title[i] "</h3>" # numbered heading, e.g. "1. Saying Hello"
  nbuf=0; codebuf=""; incode=0                   # reset per-section state: buffer, code accumulator, code flag
  getline line < f                             # skip the "# Title" line
  while((getline line < f) > 0){                 # stream the rest of the file line by line
    if(line ~ /^```clips/){ flush(); incode=1; codebuf=""; continue }  # code fence opens: flush prose, start collecting code
    if(incode){ if(line ~ /^```/){ emit_code(slug[i]); incode=0 } else { codebuf=codebuf line "\n" } continue }  # in code: closing fence emits, else accumulate
    if(line ~ /^[ \t]*$/){ flush(); continue }   # blank line ends the current block
    buf[++nbuf]=line                             # otherwise buffer the line as part of the current block
  }
  flush(); close(f)                              # flush any trailing block and close the file handle
  # derived bottom-nav
  print "          <ul class=\"bottom-nav\">"    # open the previous/current/next navigation list
  if(i>0) print "            <li class=\"previous\"><a href=\"#" slug[i-1] "\">\342\206\220 " i-1 ". " title[i-1] "</a></li>"  # prev link, by slug (\342\206\220 = left arrow)
  else    print "            <li class=\"previous\"></li>"                     # first chapter: empty prev slot
  print "            <li class=\"current\">" i ". " title[i] "</li>"           # current chapter label (JS swaps in a dropdown)
  if(i<N-1) print "            <li class=\"next\"><a href=\"#" slug[i+1] "\">" i+1 ". " title[i+1] " \342\206\222</a></li>"  # next link, by slug (\342\206\222 = right arrow)
  else      print "            <li class=\"next\"></li>"                       # last chapter: empty next slot
  print "          </ul>"                        # close the nav list
  print "        </section>"                     # close the section
  print ""                                       # blank line between sections
}

# BEGIN: no input files are read as records; everything is driven from here.
BEGIN{
  N=0                                            # N = number of chapters found
  while((getline s < "chapters-index") > 0){ if(s ~ /[^ \t]/){ slug[N]=trim(s); N++ } }  # read ordered, non-blank slugs
  for(i=0;i<N;i++){ f="chapters/" slug[i] ".md"; getline t < f; close(f)   # pass 1: read the first line of each file...
                    sub(/^# */,"",t); title[i]=trim(t) }                   # ...strip the "# " to cache the title (needed for nav)
  for(i=0;i<N;i++) render(i)                     # pass 2: render every section in order
}
'
cat template/tail.html  # emit the static bottom of the page (shared editor panel + scripts)
