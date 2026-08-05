## updated MDSumner@gmail.com 2026-08-05
##
## vendored earcut.hpp is now mapbox/earcut.hpp master at
##   f25bc765e3084583b7350080319c29ad87bf5857  (2026-07-07)
## which is v3.2.3 plus three post-tag fixes we want:
##   #134 guard against degenerate edges (std::sort is UB on NaN, unlike JS sort)
##   #133 fix member shadowing warnings (MSVC C4458 under strict settings)
##   f917bfc cast container size to fix Qt compilation warnings
## previous vendored version was 6d18edf (2020-01-24, v2.2.2 parity).
##
## notes on this update
## * the public entry point mapbox::earcut<N>(polygon) is unchanged, so
##   src/decido.cpp and inst/include/decido/decido.hpp needed no changes
## * the header now needs C++14 (std::make_unique); C++11 no longer compiles.
##   R >= 4.3 defaults to gnu++17 so no CXX_STD is set
## * the local patch removing an unused 'iterations' variable (34f4c0e) is no
##   longer needed, upstream is clean under -Wall -Wextra -Wshadow -Wpedantic
## * triangle counts and total areas are unchanged, but the specific index
##   output differs, so hard-coded expectations in
##   tests/testthat/test-basic-index.R were regenerated
## * upstream comments were transliterated to ASCII (em dashes, arrows) to
##   keep the shipped header plain ASCII
## * upstream also gained an opt-in mapbox::refine() Delaunay post-pass, not
##   currently exposed by decido

## previous note, kept for reference:
## passes check, may need to port in Wall fixes by mpadge e.g.
##  https://github.com/hypertidy/decido/blame/master/inst/include/earcut.h
## branch update-earcut.hpp
## check with dcooley
## check revdeps, check rhub and winbuilder

## record of bash commands to update the source header earcut.h
"
       cd data-raw
       git clone https://github.com/mapbox/earcut.hpp
       cp earcut.hpp/include/mapbox/earcut.hpp ../inst/include/
       cp earcut.hpp/LICENSE ../inst/include/
       cd earcut.hpp
       git log -n 5  >  ../../inst/include/mapbox-earcut.hpp.git.log
       cd ../../inst/include
       mv earcut.h earcut.hold
       mv earcut.hpp earcut.h
       "
