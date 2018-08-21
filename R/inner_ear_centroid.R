#' @noRd
#' @param x
#'
#' @examples
#' xyz <- iso_data$xyz
#' image(xyz, useRaster = TRUE)
#'
#' xylist <- vector("list", length(b))
#' for (i in seq_along(b)) {
#'   xylist[[i]] <- do.call(rbind, purrr::map(isoband_to_rings(b[[i]]), ~inner_ear_centroid(.x[c("x", "y")])))
#' }
#' purrr::walk(b, function(xa) lapply(isoband_to_rings(xa), polygon))
#' purrr::walk(xylist, points)
na_bind <- function(x) {
  head(do.call(rbind, lapply(isoband_to_rings(x), function(a) rbind(a, NA))), -1)
}
isoband_to_rings <- function(x) {
  x <- tibble::as_tibble(x)
  id <- x$id
  split(x[c("x", "y")], id)[unique(id)]
}
inner_ear_centroid <- function(x) {
  ## x is xy
  idx <- decido::earcut(x)
  ## pick a random one
  i <- sample(length(idx)/3, 1)
  # browser()
  matrix(colMeans(x[idx[(i-1) * 3 + (1:3)], ]), ncol = 2L)
}
