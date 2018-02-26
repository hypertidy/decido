#' earcut
#'
#' earcut description
#'
#' earcut details
#' @param x x-coordinate
#' @param y y-coordinate
#' @param holes index of starting position of each hole in x,y, leave set to `0` if no holes
#' @export
#' @examples
#' x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
#' y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
#' (ind <- earcut(x, y))
#' plot_ears(cbind(x, y), ind)
#' x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
#'      0.2, 0.5, 0.5, 0.3, 0.2)
#' y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
#'      0.2, 0.2, 0.4, 0.6, 0.4)
#' ind <- earcut(x, y, holes = 8)
#' plot_ears(cbind(x, y), ind)
#' ## add another hole
#' x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
#'      0.2, 0.5, 0.5, 0.3, 0.2,
#'       0.15, 0.23, 0.2)
#' y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
#'      0.2, 0.2, 0.4, 0.6, 0.4,
#'       0.65, 0.65, 0.81)
#' ind <- earcut(x, y, holes = c(8, 13))
#' plot_ears(cbind(x, y), ind, col = "grey")
#' ## more than one hole
#' ## but the two inside holes are open to each other
#' ## (so we can use the same data for one hole or two)
#' x <- c(0, 0, 1, 1,
#'        0.4, 0.2, 0.2, 0.4,
#'        0.6, 0.8, 0.8, 0.6
#' )
#' y <- c(0, 1, 1, 0,
#'        0.2, 0.2, 0.4, 0.4,
#'        0.6, 0.6, 0.4, 0.4
#' )
#' plot(x, y, type = "n")
#' ind <- decido::earcut(x, y, holes = c(5, 9))
#' plot_ears(cbind(x, y), ind, col = "grey")
#' plot_holes(cbind(x, y), holes = c(5, 9), col = "grey")
#' ind <- decido::earcut(x, y, holes = 5)
#' plot_ears(cbind(x, y), ind, col = "grey")
#' plot_holes(cbind(x, y), holes = 5, col = "grey")
earcut <- function(x, y, holes = 0, ...) {
  ## convert holes to C++ 0-based
  if (any(holes < 0)) stop("'holes' must be zero, or a vector of positive vaues")
  if (any(holes < 1) && length(holes) > 1) stop("cannot mix index 0 with non-zero for 'holes'")
  if (any(holes < 4) && length(holes) > 1) stop("no hole can begin before element 4")
  if (any(holes > (length(x) - 2))) stop("no hole can begin more than 3 elements from the end")
  nholes <- length(holes)
  if (holes[1] == 0) nholes <- 0
  earcut_cpp(x, y, holes = holes - 1, numholes = nholes) + 1L
}
#' Plot ears or polygons
#'
#' Plot the triangles for earcut.
#' @param xy matrix of x, y coordinates
#' @param idx index of triangles
#' @param holes index of starting position of holes (see `earcut`)
#' @param ... arguments to polypath
#' @export
plot_ears <- function(xy, idx, add = FALSE, ...) {
  if (!add) plot(x, y, asp = 1)
  apply(matrix(idx, 3), 2, function(i) polypath(xy[i, ], ...))
}

#' @name plot_ears
#' @export
plot_holes <- function(xy, holes = 0, add = FALSE, ...) {
  if (holes[1] > 0) {
    g <- c(0, cumsum(abs(diff(seq_len(nrow(xy)) %in% holes))))
    g[holes] <- g[holes] + 1
    g <- as.integer(factor(g))
  }

  xyna <- utils::head(do.call(rbind, lapply(split(as.data.frame(xy), g), function(itab) rbind(itab, NA))), -1L)
  if (!add) plot(xyna, type = "n", asp = 1)
  polypath(xyna, rule = "evenodd", ...)

}
