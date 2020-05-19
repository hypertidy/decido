#include "decido.h"

using namespace Rcpp;

#include "decido/decido.hpp"

// [[Rcpp::export]]
IntegerVector earcut_cpp(
    NumericVector x,
    NumericVector y,
    IntegerVector holes,
    IntegerVector numholes
  ) {
  return decido::api::earcut( x, y, holes, numholes );
}


// [[Rcpp::export]]
IntegerVector earcut_sfg( SEXP& sfg ) {
  return decido::api::earcut( sfg );
}

