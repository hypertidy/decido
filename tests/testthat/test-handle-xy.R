context("test-handle-xy.R")

test_that("handle xy works", {
expect_equal(handle_xy(list(1:4, 4:7)), structure(c(1L, 2L, 3L, 4L, 4L, 5L, 6L, 7L), .Dim = c(4L, 2L), .Dimnames = list(
    NULL, c("x", "y"))))
  expect_that(handle_xy(list(a = 1:4, b = 1:4)), is_a("matrix"))
  expect_warning(handle_xy(list(a = 1:4, b = 1:4, c = 1:4)), "expected two columns, x/y")
  expect_warning(handle_xy(cbind(a = 1:4, b = 1:4, c = 1:4)), "expected two columns, x/y")
  expect_warning(handle_xy(list(a = 1:2, b = 1:2, c = 1:2)), "fewer than 3 coordinates supplied")
})
