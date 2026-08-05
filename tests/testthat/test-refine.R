context("test-refine.R")

tri_area <- function(xy, idx) {
  apply(matrix(idx, 3), 2, function(i) {
    p <- xy[i, ]
    abs(0.5 * (p[1, 1] * (p[2, 2] - p[3, 2]) +
               p[2, 1] * (p[3, 2] - p[1, 2]) +
               p[3, 1] * (p[1, 2] - p[2, 2])))
  })
}

min_angle <- function(xy, idx) {
  apply(matrix(idx, 3), 2, function(i) {
    p <- xy[i, ]
    d <- function(a, b) sqrt(sum((a - b)^2))
    A <- d(p[2, ], p[3, ]); B <- d(p[1, ], p[3, ]); C <- d(p[1, ], p[2, ])
    ang <- function(o, q, r) acos(max(-1, min(1, (q^2 + r^2 - o^2) / (2 * q * r))))
    min(ang(A, B, C), ang(B, A, C), ang(C, A, B)) * 180 / pi
  })
}

star <- local({
  th <- seq(0, 2 * pi, length.out = 61)[-61]
  cbind(cos(th) * (1 + 0.35 * sin(7 * th)), sin(th) * (1 + 0.35 * sin(7 * th)))
})

test_that("refine defaults to off", {
  expect_equal(earcut(star), earcut(star, refine = FALSE))
})

test_that("refine keeps the triangulation valid", {
  plain <- earcut(star)
  fine <- earcut(star, refine = TRUE)

  expect_length(fine, length(plain))
  expect_equal(sort(unique(fine)), sort(unique(plain)))
  expect_equal(sum(tri_area(star, fine)), sum(tri_area(star, plain)))
  expect_false(identical(plain, fine))
})

test_that("refine removes sliver triangles", {
  expect_gt(min(min_angle(star, earcut(star, refine = TRUE))),
            min(min_angle(star, earcut(star))))
})

test_that("refine works with holes", {
  x <- c(0, 0, 1, 1, 0.4, 0.2, 0.2, 0.4, 0.6, 0.8, 0.8, 0.6)
  y <- c(0, 1, 1, 0, 0.2, 0.2, 0.4, 0.4, 0.6, 0.6, 0.4, 0.4)
  xy <- cbind(x, y)

  plain <- earcut(xy, holes = c(5, 9))
  fine <- earcut(xy, holes = c(5, 9), refine = TRUE)

  expect_length(fine, length(plain))
  expect_equal(sum(tri_area(xy, fine)), sum(tri_area(xy, plain)))
})

test_that("refine is validated", {
  expect_error(earcut(star, refine = NA), "single TRUE or FALSE")
  expect_error(earcut(star, refine = c(TRUE, TRUE)), "single TRUE or FALSE")
  expect_error(earcut(star, refine = "yes"), "single TRUE or FALSE")
})

test_that("refine did not steal a positional argument", {
  ## revdeps call earcut(xy, holes) and pass extra args through ...
  x <- c(0, 0, 1, 1, 0.4, 0.2, 0.2, 0.4)
  y <- c(0, 1, 1, 0, 0.2, 0.2, 0.4, 0.4)
  expect_equal(earcut(cbind(x, y), 5, "ignored"), earcut(cbind(x, y), 5))
})
