## Transliterate the vendored earcut.h to plain ASCII.
## Upstream comments contain em dashes, arrows and similar. They are harmless
## in themselves, but a pure ASCII package source is easier to live with.
##
## The characters to replace are written as \u escapes so this file is itself
## pure ASCII and behaves identically in a C locale and in a UTF-8 one.
p <- "inst/include/earcut.h"

raw <- readBin(p, "raw", file.info(p)$size)
txt <- rawToChar(raw)
Encoding(txt) <- "UTF-8"

from <- c(
  "\u2014",  # em dash
  "\u2013",  # en dash
  "\u2192",  # rightwards arrow
  "\u2018",  # left single quote
  "\u2019",  # right single quote
  "\u201c",  # left double quote
  "\u201d",  # right double quote
  "\u2026",  # horizontal ellipsis
  "\u00b7",  # middle dot
  "\u00b2",  # superscript two
  "\u00d7",  # multiplication sign
  "\u2264",  # less than or equal
  "\u2265",  # greater than or equal
  "\u00a0"   # non-breaking space
)
to <- c("--", "-", "->", "'", "'", "\"", "\"", "...", "*", "^2", "x", "<=", ">=", " ")

for (i in seq_along(from)) {
  txt <- gsub(from[i], to[i], txt, fixed = TRUE)
}

writeBin(charToRaw(txt), p)

## fail loudly rather than shipping something that slipped through
lines <- readLines(p, warn = FALSE)
bad <- grep("[^\001-\177]", lines, useBytes = TRUE)
if (length(bad)) {
  stop("non-ASCII remains in ", p, " on line(s): ", paste(bad, collapse = ", "))
}
cat(p, "is plain ASCII\n")
