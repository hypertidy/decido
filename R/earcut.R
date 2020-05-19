handle_xy <- function(xy) {
  if (is.list(xy) && length(xy) == 2L) xy <- stats::setNames(xy, c("x", "y"))
  if (is.list(xy)) xy <- do.call(cbind, xy)
  if (!dim(xy)[2L] == 2L) warning("expected two columns, x/y")
  if (dim(xy)[2L] < 2L) stop("expected two columns, x/y")
  if (dim(xy)[1L] < 3L) warning("fewer than 3 coordinates supplied")
  xy
}

#' Constrained polygon triangulation
#'
#' Produce a triangulation index into x,y coordinates of a polygon
#' that may include holes. Holes are specified by input argument `holes`
#' which marks the starting index of each hole, if any.
#'
#' Triangles are returned in counter-clockwise orientation, a common convention that ascribes a positive area
#' to the triangle. (Orientation may be collinear or numerically ambiguous and so may be undetermined).
#'
#' Ear cutting (or ear clipping) applies constrained triangulation by
#' successively 'cutting' triangles from a polygon defined by path/s. Holes are supported, the earcut library works with
#' single-island-with-holes polygons, analogous to the POLYGON type in simple features.
#'
#' To understand the specification of holes, see the examples with comment
#' starting "1) Notice how the hole begins ..." in relation to the example code.
#' @param xy xy-coordinates, either a list, matrix, or data frame
#' @param holes index of starting position of each hole in x,y, leave set to `0` if no holes
#' @param ... unused
#' @return integer vector of triangle index, in sets of three
#' @export
#' @seealso plot_ears
#' @examples
#' ## single ring polygon
#' x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
#' y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
#' (ind <- earcut(cbind(x, y)))
#' plot_ears(cbind(x, y), ind)
#'
#' ## polygon with a hole
#' x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
#'      0.2, 0.5, 0.5, 0.3, 0.2)
#' y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
#'      0.2, 0.2, 0.4, 0.6, 0.4)
#' ind <- earcut(cbind(x, y), holes = 8)
#' plot_ears(cbind(x, y), ind)
#'
#' ## 1) Notice how the hole begins at index 8,
#' ## hence holes = 8 above, and holes = c(8, 13) below
#' plot_ears(cbind(x, y), ind, col = "grey", border = NA)
#' text(x, y, labels = seq_along(x), pos = 2)
#'
#' ## add another hole
#' x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
#'      0.2, 0.5, 0.5, 0.3, 0.2,
#'       0.15, 0.23, 0.2)
#' y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
#'      0.2, 0.2, 0.4, 0.6, 0.4,
#'       0.65, 0.65, 0.81)
#' ind <- earcut(cbind(x, y), holes = c(8, 13))
#' plot_ears(cbind(x, y), ind, col = "grey")

#' # simpler shape with more than one hole
#' # the two inside holes are open to each other
#' # (so we can use the same data for one hole or two)
#' x <- c(0, 0, 1, 1,
#'        0.4, 0.2, 0.2, 0.4,
#'        0.6, 0.8, 0.8, 0.6
#' )
#' y <- c(0, 1, 1, 0,
#'        0.2, 0.2, 0.4, 0.4,
#'        0.6, 0.6, 0.4, 0.4
#' )
#' ind <- decido::earcut(cbind(x, y), holes = c(5, 9))
#' plot_ears(cbind(x, y), ind, col = "grey")
#' plot_holes(cbind(x, y), holes = c(5, 9), col = "grey")
#' ind <- decido::earcut(cbind(x, y), holes = 5)
#' plot_ears(cbind(x, y), ind, col = "grey")
#' plot_holes(cbind(x, y), holes = 5, col = "grey")
earcut <- function(xy, holes = 0, ...) {
 UseMethod("earcut")
}
#' @name earcut
#' @export
earcut.default <- function(xy, holes = 0L, ...) {
  xy <- handle_xy(xy)
  x <- xy[ ,1L]
  y <- xy[ ,2L]
  ## convert holes to C++ 0-based
  if (any(holes < 0)) stop("'holes' must be zero, or a vector of positive vaues")
  if (any(holes < 1) && length(holes) > 1) stop("cannot mix index 0 with non-zero for 'holes'")
  if (any(holes < 4) && length(holes) > 1) stop("no hole can begin before element 4")
  if (any(holes > (length(x) - 2))) stop("no hole can begin later than 3 elements from the end")
  nholes <- length(holes)
  if (holes[1] == 0) {
    ## a nonsense situation, so we reset to be sure
    nholes <- 0L
    holes <- 0L
  }
  earcut_cpp(x, y, holes = as.integer(holes - 1), numholes = as.integer(nholes)) + 1L
}
#' Plot ears or polygons
#'
#' Plot the triangles produced by [earcut], or plot the polygon paths
#' using the same interface as earcut uses. This allows for easy
#' comparison and checking of what the results should be.
#'
#' For both functions the first input is
#' a matrix of x,y coordinates.
#'
#' For [plot_ears] the second input is
#' the index output of earcut. The index is treated in sets of 3 values, with
#' individual calls to [polypath] to draw a polygon for each triangle.
#'
#' For [plot_holes] the second input is the `holes` argument that would
#' be used for earcut. This is used to split the coordinates at these positions,
#' inserting `NA` values as per the mechanism used by [graphics::polypath] to
#' break coordinates into separate polygon rings. (There's no winding rule here
#' plot_rules is hard-coded to always use the evenodd rule, so that winding
#' order may be ignored).
#' @param xy xy-coordinates, either a list, matrix, or data frame
#' @param idx index of triangles
#' @param holes index of starting position of holes (see [earcut])
#' @param add add to current plot, or create a new
#' @param ... arguments to polypath
#' @export
#' @importFrom graphics plot polypath
#' @seealso earcut
#' @examples
#' ## after ?polypath
#' x <- cbind(c(.1, .1, .9, .9,   .2, .2, .8, .8),
#'            c(.1, .9, .9, .1,   .2, .8, .8, .2))
#' plot_holes(x, holes = 5, col = "grey")
plot_ears <- function(xy, idx, add = FALSE, ...) {
  xy <- handle_xy(xy)
  if (!add) plot(xy, asp = 1)
  apply(matrix(idx, 3), 2, function(i) polypath(xy[i, ], ...))
  invisible(NULL)
}

#' @name plot_ears
#' @export
plot_holes <- function(xy, holes = 0, add = FALSE, ...) {
  xy <- handle_xy(xy)
  if (holes[1] > 0) {
    g <- c(0, cumsum(abs(diff(seq_len(nrow(xy)) %in% holes))))
    g[holes] <- g[holes] + 1
    g <- as.integer(factor(g))
    xy <- utils::head(do.call(rbind, lapply(split(as.data.frame(xy), g), function(itab) rbind(itab, NA))), -1L)

  }

  if (!add) plot(xy, type = "n", asp = 1)
  polypath(xy, rule = "evenodd", ...)
  invisible(NULL)
}
