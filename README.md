
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R-CMD-check](https://github.com/hypertidy/decido/workflows/R-CMD-check/badge.svg)](https://github.com/hypertidy/decido/actions)
[![R\_build\_status](https://github.com/hypertidy/decido/workflows/test-coverage/badge.svg)](https://github.com/hypertidy/decido/actions)
[![R\_build\_status](https://github.com/hypertidy/decido/workflows/pkgdown/badge.svg)](https://github.com/hypertidy/decido/actions)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Travis-CI Build
Status](http://badges.herokuapp.com/travis/hypertidy/decido)](https://travis-ci.org/hypertidy/decido)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/hypertidy/decido?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/decido)
[![Coverage
status](https://codecov.io/gh/hypertidy/decido/branch/master/graph/badge.svg)](https://codecov.io/github/hypertidy/decido?branch=master)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/decido)](https://CRAN.R-project.org/package=decido)
[![CRAN
status](https://www.r-pkg.org/badges/version/decido)](https://CRAN.R-project.org/package=decido)
<!-- badges: end -->

# decido

The goal of decido is to provide an R binding to the Mapbox library
[earcut.hpp](https://github.com/mapbox/earcut.hpp) for constrained
polygon triangulation. Decido is aimed at package developers at the
moment, there are not high-level classes or objects but the earcut
functionality can be easily used in higher-level tools or just used
directly.

Ear cutting (or ear clipping) applies constrained triangulation by
successively ‘cutting’ triangles from a polygon defined by path/s. Holes
are supported, the earcut library works with single-island-with-holes
polygons, analogous to the POLYGON type in simple features.

This augments the Javascript version available in
[rearcut](https://github.com/hypertidy/rearcut.git) (also an R wrapper
of the JS version by Mapbox). Only very minimal comparison testing has
yet been done to [compare these
implementations](http://rpubs.com/cyclemumner/364247).

## Installation

Install the released version from CRAN.

``` r
## install.packages("remotes")
remotes::install_cran("decido")
```

You can install the development version from GitHub with the following
code. You will need the [set of development
tools](https://www.rstudio.com/products/rpackages/devtools/) for
building source packages with binary code.

``` r
## install.packages("devtools")
devtools::install_github("hypertidy/decido", build_vignettes = TRUE)
```

## Example

This is a basic example of triangulating a single-ring polygon. The
output is a vector of triplet indices defining each triangle.

``` r
library(decido)
x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
earcut(cbind(x, y))
#>  [1] 2 1 7 7 6 5 5 4 3 2 7 5 5 3 2
```

See the [documentation](https://hypertidy.github.io/decido/) and
[vignette](https://hypertidy.github.io/decido/articles/decido.html) for
more.

Open the getting started vignette.

``` r
vignette("decido", package = "decido")
```

## Development

This is motivated by the topology aspirations of
[silicate](https://CRAN.r-project.org/package=silicate). We need tools
for decomposing shape data into primitives for analysis and
visualization. Decomposition into graph types is already well supported
and exercised, but triangulations of paths versus triangulations from
edges are two key facilities needed for greater control.

This broader project is fairly well advanced in silicate which provides
ear-cutting triangulations and enhanced with high-quality methods in
[hypertidy/anglr](https://github.com/hypertidy/anglr).

To triangulate sf polygons see [function
here](https://github.com/hypertidy/decido/issues/9). For high-quality
triangulations of sf polygons directly see
[sfdct](https://CRAN.r-project.org/package=sfdct).

## Other implementations

Ear clipping (or ear cutting) is also available in the
[rgl](https://CRAN.r-project.org/package=rgl) function `triangulate`
(implemented in R), and in the
[lawn](https://CRAN.r-project.org/package=lawn) function
`lawn_tesselate` (implemented via the Mapbox Javascript library earcut).
In rgl the function also classifies input coordinates according to their
nesting, a necessary first step if the relaionship between holes and
islands is not known. The `INLA` package has some kind of
constraint-based triangulation, but I don’t yet know the details.

In comparison to path-based ear-clipping, other libraries ‘Triangle’ and
‘CGAL’ provide edge-based *mostly Delaunay* triangulation. The Triangle
library is available in the R package
[RTriangle](https://CRAN.r-project.org/package=RTriangle) and for (some)
R spatial formats in [sfdct](https://CRAN.r-project.org/package=sfdct).
Experimental implementations binding CGAL are in
[rcgal](https://github.com/s-u/rcgal) and
[laridae](https://github.com/hypertidy/laridae).

Do you know of others? Let me know\! Triangulation is common across many
R packages, but constrained algorithms are pretty rare (it’s hard).
There are many Delaunay and other non-constrained implementations in
many packages, and I’m compiling a list of those as well. OTOH there’s
rgeos, sf, deldir, geometry, tripack, spatstat, akima, several
mesh-related packages Rvcg, meshsimp, icosa, webglobe …

-----

Please note that the decido project is released with a [Contributor Code
of Conduct](CODE_OF_CONDUCT.md). By participating in this project you
agree to abide by its terms.
