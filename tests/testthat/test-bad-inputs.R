context("test-bad-inputs.R")

test_that("bad inputs handled", {
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)

  expect_error(earcut(cbind(x, y), holes = c(-1, 0)),
               "must be zero, or a vector of positive")
  expect_error(earcut(cbind(x, y), holes = c(0, 4)),
               "cannot mix")
  expect_error(earcut(cbind(x, y), holes = c(3, 8)),
               "no hole can begin before element 4")
  expect_error(earcut(cbind(x, y), holes = 7),
               "no hole can begin later than 3 elements from the end")


   expect_error(expect_warning(earcut(matrix(x), holes = 7)), "expected two columns, x/y")
})
