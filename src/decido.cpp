#include <Rcpp.h>
#include <array>
using namespace Rcpp;
#include "earcut.h"

#include "decido/decido.hpp"

// [[Rcpp::export]]
Rcpp::IntegerVector earcut_cpp(
    NumericVector x,
    NumericVector y,
    IntegerVector holes,
    IntegerVector numholes
  ) {
  return decido::api::earcut( x, y, holes, numholes );
}


// [[Rcpp::export]]
Rcpp::IntegerVector earcut_sfg( SEXP& sfg ) {
  return decido::api::earcut( sfg );
}

