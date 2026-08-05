## Helpers for asserting that a triangulation is correct without pinning the
## exact index. earcut's choice of bridge segment when joining holes depends on
## floating point comparisons, so the specific triangles it returns can differ
## between compilers and architectures (notably where FMA contraction is on, as
## on arm64 macOS) while remaining an equally valid triangulation. Assert the
## properties that must hold everywhere instead.

## signed area of a closed ring given as a 2-column matrix
ring_area <- function(xy) {
  n <- nrow(xy)
  j <- c(seq_len(n)[-1], 1L)
  sum(xy[, 1] * xy[j, 2] - xy[j, 1] * xy[, 2]) / 2
}

## area of each triangle in an earcut index
tri_area <- function(xy, idx) {
  apply(matrix(idx, 3), 2, function(i) {
    p <- xy[i, ]
    abs(0.5 * (p[1, 1] * (p[2, 2] - p[3, 2]) +
               p[2, 1] * (p[3, 2] - p[1, 2]) +
               p[3, 1] * (p[1, 2] - p[2, 2])))
  })
}

## area the polygon ought to have, outer ring less any holes
polygon_area <- function(xy, holes = 0) {
  starts <- if (identical(holes, 0) || holes[1] == 0) 1L else c(1L, holes)
  ends <- c(if (length(starts) > 1) starts[-1] - 1L, nrow(xy))
  rings <- Map(function(s, e) abs(ring_area(xy[s:e, , drop = FALSE])), starts, ends)
  rings[[1]] - sum(unlist(rings[-1]))
}

expect_valid_triangulation <- function(xy, idx, holes = 0, ntri = NULL) {
  expect_true(length(idx) %% 3 == 0)
  expect_true(all(idx >= 1L & idx <= nrow(xy)))
  expect_equal(sum(tri_area(xy, idx)), polygon_area(xy, holes))
  if (!is.null(ntri)) expect_equal(length(idx) / 3, ntri)
  invisible(idx)
}
