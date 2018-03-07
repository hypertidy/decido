context("test-plot.R")

test_that("plot variants", {
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
  ind <- earcut(cbind(x, y))

  expect_silent(plot_ears(cbind(x, y), ind))
  expect_silent(plot_ears(cbind(x, y), ind, add = TRUE))
  expect_silent(plot_holes(cbind(x, y)))
  expect_silent(plot_holes(cbind(x, y), add = TRUE))

  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
         0.2, 0.5, 0.5, 0.3, 0.2,
         0.15, 0.23, 0.2)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
         0.2, 0.2, 0.4, 0.6, 0.4,
         0.65, 0.65, 0.81)
  ind <- earcut(cbind(x, y), holes = c(8, 13))
  expect_silent(plot_ears(cbind(x, y), ind))
  expect_silent(plot_ears(cbind(x, y), ind, add = TRUE))
  expect_silent(plot_holes(cbind(x, y), holes = c(8, 13)))
  expect_silent(plot_holes(cbind(x, y), holes = c(8, 13), add = TRUE))

})


test_that("plot variants in reverse", {
  x <- rev(c(0, 0, 0.75, 1, 0.5, 0.8, 0.69))
  y <- rev(c(0, 1, 1, 0.8, 0.7, 0.6, 0))
  ind <- earcut(cbind(x, y))

  expect_silent(plot_ears(cbind(x, y), ind))
  expect_silent(plot_ears(cbind(x, y), ind, add = TRUE))
  expect_silent(plot_holes(cbind(x, y)))
  expect_silent(plot_holes(cbind(x, y), add = TRUE))

  x <- c(rev(c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)),
         0.2, 0.5, 0.5, 0.3, 0.2,
         0.15, 0.23, 0.2)
  y <-  c(rev(c(0, 1, 1, 0.8, 0.7, 0.6, 0)),
         0.2, 0.2, 0.4, 0.6, 0.4,
         0.65, 0.65, 0.81)
  ind <- earcut(cbind(x, y), holes = c(8, 13))
  expect_silent(plot_ears(cbind(x, y), ind))
  expect_silent(plot_ears(cbind(x, y), ind, add = TRUE))
  expect_silent(plot_holes(cbind(x, y), holes = c(8, 13)))
  expect_silent(plot_holes(cbind(x, y), holes = c(8, 13), add = TRUE))

})
