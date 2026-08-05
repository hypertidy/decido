#include "decido.h"

using namespace Rcpp;

#include "decido/decido.hpp"

// [[Rcpp::export]]
IntegerVector earcut_cpp(
    NumericVector x,
    NumericVector y,
    IntegerVector holes,
    IntegerVector numholes,
    bool refine = false
  ) {
  return decido::api::earcut( x, y, holes, numholes, refine );
}


// [[Rcpp::export]]
IntegerVector earcut_sfg( SEXP& sfg, bool refine = false ) {
  return decido::api::earcut( sfg, refine );
}

