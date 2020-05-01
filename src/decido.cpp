#include <Rcpp.h>
#include <array>
using namespace Rcpp;
#include "earcut.h"

#include "decido/decido.hpp"

// [[Rcpp::export]]
IntegerVector earcut_cpp(NumericVector x, NumericVector y,
                     IntegerVector holes,
                     IntegerVector numholes) {

  // The index type. Defaults to uint32_t, but you can also pass uint16_t if you know that your
  // data won't have more than 65536 vertices.
  using N = uint32_t;
  Polygon poly;

  int vcount = static_cast <int> (x.length());
  Point pt;
  Polygons polyrings;
 // if (numholes.size())
//    Rcout << "numholes[0]:" << numholes[0] << std::endl;
  int hole_index = 0;
  for (int ipoint = 0; ipoint < vcount; ipoint++) {
    pt = {x[ipoint], y[ipoint]};

    // don't add the point if we are starting a new ring
    if (numholes.size() && numholes[0] > 0) {
      if (hole_index < holes.size()) {
//         throw std::runtime_error("bounds");
      int ihole = holes[hole_index];
      if (ipoint == ihole) {
        // Rprintf("pushback poly %i\n", ipoint + 1);
        polyrings.push_back(poly);
        poly.clear();
        hole_index++;
      }
      }
    }
    // now add the point
    poly.push_back(pt);
  }

  // ensure we catch the last poly ring
  polyrings.push_back(poly);

  // Run tessellation
  // Returns array of indices that refer to the vertices of the input polygon.
  // Three subsequent indices form a triangle.
  std::vector<N> indices = mapbox::earcut<N>(polyrings);
  return Rcpp::wrap( indices );
}


// [[Rcpp::export]]
SEXP earcut_sfc( Rcpp::List& sfg ) {

  Polygons polyrings = Rcpp::as< Polygons >( sfg );

  std::vector< uint32_t > indices = mapbox::earcut< uint32_t >( polyrings );
  return Rcpp::wrap( indices );
}

