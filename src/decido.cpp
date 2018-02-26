#include <Rcpp.h>
#include <array>
using namespace Rcpp;
#include "earcut.h"


// [[Rcpp::export]]
IntegerVector earcut_cpp(NumericVector x, NumericVector y,
                     IntegerVector holes = -1,
                     IntegerVector numholes = 0) {
  using Coord = double;
  // The index type. Defaults to uint32_t, but you can also pass uint16_t if you know that your
  // data won't have more than 65536 vertices.
  using N = uint32_t;
  // Create array
  using Point = std::array<Coord, 2>;
  using Polygon = std::vector<Point>;
  Polygon poly;
  using Polygons = std::vector<Polygon>;
  int vcount = x.length();
  Point pt;
  Polygons polyrings;
 // Rprintf("numholes %i\n", numholes[0]);
  int hole_index = 0;
  for (int ipoint = 0; ipoint < vcount; ipoint++) {
    pt = {x[ipoint], y[ipoint]};
    // don't add the point if we are starting a new ring
    if (numholes[0] > 0) {
      if (ipoint == holes[hole_index]) {
       // Rprintf("pushback poly %i\n", ipoint + 1);
        polyrings.push_back(poly);
        poly.clear();
        hole_index = hole_index + 1;
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

  IntegerVector out(indices.size());
  for (int j = 0; j < out.length(); j++){
    out[j] = indices[j];
  }
  return out;
}

