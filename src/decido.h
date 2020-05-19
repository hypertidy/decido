#include <Rcpp.h>
#include <array>
#include "earcut.h"

Rcpp::IntegerVector earcut_cpp(
    Rcpp::NumericVector x,
    Rcpp::NumericVector y,
    Rcpp::IntegerVector holes,
    Rcpp::IntegerVector numholes
  );


Rcpp::IntegerVector earcut_sfg( SEXP& sfg );
