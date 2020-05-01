#' @useDynLib 'decido', .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL

#' @keywords internal
"_PACKAGE"


#' decido
#'
#' Provides constrained triangulation of polygons. Ear cutting (or
#' ear clipping) applies constrained triangulation by successively 'cutting'
#' triangles from a polygon defined by path/s. Holes are supported.
#' This package wraps the 'header-only' library 'earcut.hpp'
#' <https://github.com/mapbox/earcut.hpp.git>.
#'
#' @name decido-package
#' @docType package
NULL
