
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing) [![Travis-CI Build Status](http://badges.herokuapp.com/travis/hypertidy/decido?branch=master&env=BUILD_NAME=trusty_release&label=linux)](https://travis-ci.org/hypertidy/decido) [![Build Status](http://badges.herokuapp.com/travis/hypertidy/decido?branch=master&env=BUILD_NAME=osx_release&label=osx)](https://travis-ci.org/hypertidy/decido) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/decido?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/decido) [![Coverage status](https://codecov.io/gh/hypertidy/decido/branch/master/graph/badge.svg)](https://codecov.io/github/hypertidy/decido?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/tidync)](https://cran.r-project.org/package=tidync)

decido
======

The goal of decido is to provide an R binding to the Mapbox library [earcut.hpp](https://github.com/mapbox/earcut.hpp) for constrained polygon triangulation.

Ear cutting (or ear clipping) applies constrained triangulation by successively 'cutting' triangles from a polygon defined by path/s. Holes are supported, the earcut library works with single-island-with-holes form polygons, analogous to the POLYGON type in simple features.

This augments the Javascript version available in [rearcut](https://github.com/hypertidy/rearcut.git) (also an R wrapper of the JS version by Mapbox). No comparison or testing has yet been done to compare these implementations.

In comparison to path-based ear-clipping, other libraries 'Triangle' and 'CGAL' provide edge-based *mostly Delaunay* triangulation. The Triangle library is available in the R package [RTriangle](https://CRAN.r-project.org/package=RTriangle). Experimental implementations binding CGAL are in [rcgal](https://github.com/s-u/rcgal) and [laridae](https://github.com/hypertidy/laridae).

Installation
------------

You can install decido from with:

``` r
devtools::install_github("hypertidy/decido")
```

Development
-----------

Immediate needs:

-   wrap around complex types of multiple polygons, etc.
-   tests!

Example
-------

This is a basic example of triangulating a single-ring polygon. The output is a vector of triplet indices defining each triangle.

``` r
library(decido)
x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
earcut(x, y)
#>  [1] 2 1 7 7 6 5 5 4 3 2 7 5 5 3 2
```

See the documentation and vignette for more.

Beware!
-------

This is in active development and the functions will change.

No checking is done on input coordinates, so use at your own risk!

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
