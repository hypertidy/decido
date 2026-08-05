context("test-basic-index.R")

test_that("no-hole triangulation works", {
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
  expect_equal(earcut(cbind(x, y)),
               ## notice dynamic conversion to 1-based index
               c(1L, 0L, 6L, 6L, 5L, 4L, 4L, 3L, 2L, 4L, 2L, 1L, 4L, 1L, 6L) + 1L)

})

test_that("single-hole triangulation works", {
  ## hole starts at 9
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
       0.2, 0.5, 0.5, 0.3, 0.2)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
       0.2, 0.2, 0.4, 0.6, 0.4)
  xy <- cbind(x, y)

  ## the bridge earcut picks to join the hole depends on floating point
  ## comparisons and differs between architectures, so check the properties
  ## every valid triangulation has rather than one platform's index
  expect_valid_triangulation(xy, earcut(xy, holes = 8), holes = 8, ntri = 12)
})

test_that("two-hole triangulation works", {
  x <- c(0, 0, 1, 1, 0.4, 0.2, 0.2, 0.4, 0.6, 0.8, 0.8, 0.6)
  y <- c(0, 1, 1, 0, 0.2, 0.2, 0.4, 0.4, 0.6, 0.6, 0.4, 0.4)
  xy <- cbind(x, y)

  expect_valid_triangulation(xy, earcut(xy, holes = c(5, 9)), holes = c(5, 9), ntri = 12)
})

test_that("we can run biggish inputs (and hopefully invoke the hashing logic)", {
  earcut(ant_cont) %>% expect_length(7611) %>% sum() %>% expect_equal(9687916L)

  expect_valid_triangulation(rbind(ant_cont, ant_circle),
                             earcut(rbind(ant_cont, ant_circle), holes = 2541),
                             holes = 2541, ntri = 2659)
})
