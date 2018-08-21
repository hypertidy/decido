context("test-basic-index.R")

test_that("no-hole triangulation works", {
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
  expect_equal(earcut(cbind(x, y)),
               ## notice dynamic conversion to 1-based index
               c(1L, 0L, 6L, 6L, 5L, 4L, 4L, 3L, 2L, 1L, 6L, 4L, 4L, 2L, 1L) + 1L)

})

test_that("single-hole triangulation works", {
  ## hole starts at 9
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69,
       0.2, 0.5, 0.5, 0.3, 0.2)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0,
       0.2, 0.2, 0.4, 0.6, 0.4)
  ind <- earcut(cbind(x, y), holes = 8)
  expect_equal(ind,

               c(1L, 8L, 12L, 9L, 8L, 1L, 7L, 6L, 5L, 5L, 4L, 3L, 2L, 1L, 12L,
                 9L, 1L, 7L, 5L, 3L, 2L, 2L, 12L, 11L, 10L, 9L, 7L, 5L, 2L, 11L,10L, 7L, 5L, 5L, 11L, 10L))
})

test_that("we can run biggish inputs (and hopefully invoke the hashing logic)", {
  earcut(ant_cont) %>% expect_length(7611) %>% sum() %>% expect_equal(9670500L)

  earcut(rbind(ant_cont, ant_circle), holes = 2541) %>% expect_length(7977) %>% sum() %>% expect_equal(10511060L)

})



