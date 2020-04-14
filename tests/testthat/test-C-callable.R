test_that("C Callable earcut works", {
  library(Rcpp)
  cppFunction(
    code = '
    SEXP earcut( SEXP x , SEXP y, SEXP holes, SEXP numholes) {
      typedef SEXP R_DECIDO_FUN(SEXP, SEXP, SEXP, SEXP);
      R_DECIDO_FUN *decido_earcut_cpp = (R_DECIDO_FUN *) R_GetCCallable("decido","decido_earcut_cpp");
      return decido_earcut_cpp( x, y, holes, numholes );
    }
  '
  )


  ## single ring polygon
  x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
  y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
  (ind <- earcut(x, y, 0L, 0L))
  expect_equal(ind, c(1L, 0L, 6L, 6L, 5L, 4L, 4L, 3L, 2L, 1L, 6L, 4L, 4L, 2L, 1L))
 # plot_ears(cbind(x, y), ind + 1)  ## plus 1 because C++ context (the R-level translates)



})
