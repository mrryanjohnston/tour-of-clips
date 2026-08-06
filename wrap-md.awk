# Reflow markdown prose to ~80 cols. Leaves the title, ```code``` fences, and raw
# HTML blocks (blockquote/h4) untouched; never breaks inside a `code` span or a
# [text](url) link (a break there would corrupt the markdown).

# mdwrap(): greedily word-wrap string s to at most `width` columns. A break is
# only allowed at a space that is outside backticks (inbt) and outside a link
# (inlink), so code spans and [text](url) links are never split across lines.
function mdwrap(s,width,   out,line,tok,i,n,ch,inbt,inlink){
  n=length(s); out=""; line=""; tok=""; inbt=0; inlink=0   # line=current line, tok=current word, inbt/inlink=protection flags
  for(i=1;i<=n;i++){ ch=substr(s,i,1)            # scan one character at a time
    if(ch=="`") inbt=!inbt                        # backtick toggles "inside a `code` span"
    else if(!inbt && ch=="[") inlink=1            # "[" outside code opens a [text](url) link
    else if(!inbt && inlink && ch==")") inlink=0  # ")" closes that link (urls contain no ")")
    if(ch==" " && !inbt && !inlink){              # a space that is safe to break on
      if(tok!=""){                                # only when a word has been collected
        if(line=="") line=tok                     # first word of the line: place it
        else if(length(line)+1+length(tok)<=width) line=line " " tok  # fits -> append
        else { out=out line "\n"; line=tok }                          # too wide -> flush, word wraps down
        tok=""                                    # start the next word
      }
    } else tok=tok ch                             # any protected/non-space char extends the word
  }
  if(tok!=""){ if(line=="") line=tok                                    # flush the final trailing word:
               else if(length(line)+1+length(tok)<=width) line=line " " tok  #   append if it fits
               else { out=out line "\n"; line=tok } }                        #   else its own line
  if(line!="") out=out line "\n"                  # emit the last pending line
  return out                                      # reflowed block (ends in newline)
}
# flushprose(): wrap and print whatever prose has accumulated in buf, then clear it.
function flushprose(){ if(buf!=""){ printf "%s", mdwrap(buf,80); buf="" } }
# State: mode is ""(prose), "code"(inside a fence), or "raw"(inside an HTML block).
BEGIN{ mode=""; buf="" }
{
  line=$0                                          # current input line
  if(mode=="code"){ print line; if(line ~ /^```/) mode=""; next }        # inside a fence: pass through; closing ``` ends it
  if(line ~ /^```/){ flushprose(); print line; mode="code"; next }       # opening fence: flush prose, enter code mode
  if(mode=="raw"){ if(line ~ /^[ \t]*$/){ print ""; mode="" } else print line; next }  # inside raw html: pass through until a blank line
  if(line ~ /^[ \t]*$/){ flushprose(); print ""; next }                  # blank line: end/flush the current prose block
  if(line ~ /^# /){ flushprose(); print line; next }                     # heading line: never reflow, print as-is
  if(buf=="" && line ~ /^</){ print line; mode="raw"; next }             # a block starting with "<" is raw html -> pass through
  buf = (buf==""? line : buf " " line)            # otherwise accumulate this line into the prose block
}
END{ flushprose() }                                # flush any prose left at end of file
