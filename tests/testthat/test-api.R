context("hpp")

test_that("Rcpp api handles incorrect structures",{

  ## Vector input
  v <- 1:3
  expect_error(
    decido:::earcut_sfg( v )
    , "decido - expecting a list of matrices"
  )

  ## matrix input
  m <- matrix(1:4, ncol = 2)
  expect_error(
    decido:::earcut_sfg( m )
    , "decido - expecting a list of"
  )

  ## not a matrix
  v <- 1:3
  l <- list(v)
  expect_error(
    decido:::earcut_sfg( l )
    , "decido - a list must only contain matrices"
  )

  ## incorrect matrix dimensions
  m <- matrix(1:3, ncol = 1)
  l <- list(m)
  expect_error(
    decido:::earcut_sfg( l )
    , "decido - each point in the polygon must have exactly two coordinates"
  )


  ## too many lists
  m <- matrix(1:4, ncol = 2)
  l <- list( list( m ) )
  expect_error(
    decido:::earcut_sfg( l )
    , "decido - a list must only contain matrices"
  )

})
