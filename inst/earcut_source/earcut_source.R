## updated MDSumner@gmail.com 2020-05-18

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
