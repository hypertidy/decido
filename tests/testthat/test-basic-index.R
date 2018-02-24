context("test-basic-index.R")

test_that("no-hole triangulation works", {
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
  expect_equal(earcut(x, y),
               c(1L, 0L, 6L, 6L, 5L, 4L, 4L, 3L, 2L, 1L, 6L, 4L, 4L, 2L, 1L))

})

test_that("single-hole triangulation works", {
  ## hole starts at 9
  xx <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69, 0, 0.2,
         0.5, 0.5, 0.3, 0.2, 0.2)
  yy <- c(0, 1, 1, 0.8, 0.7, 0.6, 0, 0, 0.2,
         0.2, 0.4, 0.6, 0.4, 0.2)
  expect_equal(earcut(xx, yy, holes = 8, numholes = 1),
               c(1L, 0L, 13L, 9L, 8L, 7L, 6L, 5L, 4L, 4L, 3L, 2L, 1L, 13L, 12L,
                 9L, 7L, 6L, 4L, 2L, 1L, 1L, 12L, 11L, 10L, 9L, 6L, 4L, 1L, 11L,
                 10L, 6L, 4L, 4L, 11L, 10L))
})
