#include <Rcpp.h>
using namespace Rcpp;
#include "earcut.hpp"

//' dopey
//'
//' dopey description
//'
//' dopey details
//' @param x -ordinate
//' @param y -ordinate
//' @export
//' @examples
//' dopey(1, 2)
//' x <- c(0, 0, 0.75, 1, 0.5, 0.8, 0.69)
//' y <- c(0, 1, 1, 0.8, 0.7, 0.6, 0)
//' dopey(x, y)
// [[Rcpp::export]]
IntegerVector dopey(NumericVector x, NumericVector y) {
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
  for (int ipoint = 0; ipoint < vcount; ipoint++) {
    Point pt = {x[ipoint], y[ipoint]};
    poly.push_back({pt});
  }
  Polygons polyrings;
  polyrings.push_back(poly);
  // Run tessellation
  // Returns array of indices that refer to the vertices of the input polygon.
  // Three subsequent indices form a triangle.
  std::vector<N> indices = mapbox::earcut<N>(polyrings);

  IntegerVector out(indices.size());
  for (int j = 0; j < out.length(); j++){
    out[j] = indices[j];
  }
//  int pcnt =  polyrings.size();
//  int psize = poly.size();
//  out[0] = pcnt;
//  out[1] = psize;
  return out;
}

