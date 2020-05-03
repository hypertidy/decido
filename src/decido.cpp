#include <Rcpp.h>
#include <array>
using namespace Rcpp;
#include "earcut.h"

#include "decido/decido.hpp"


#include "sfheaders/df/sfg.hpp"
#include "sfheaders/sfg/multipolygon/sfg_multipolygon.hpp"
#include "sfheaders/sfc/sfc.hpp"

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

// [[Rcpp::export]]
SEXP earcut_sfc( Rcpp::List& sfc ) {
  // expecting an sfc objet

  Rcpp::List attributes = sfheaders::sfc::get_sfc_attributes( sfc );

  // TODO
  // - cast to POLYGON
  // - for each sfg
  // - tringulate
  // - convert to sfg_POLYGON
  R_xlen_t i;
  R_xlen_t n = sfc.length();
  Rcpp::List res( n );
  for( i = 0; i < n; ++i ) {
    SEXP poly = sfc[ i ];
    Rcpp::DataFrame df = sfheaders::df::sfg_to_df( poly );
    Rcpp::IntegerVector indices = decido::api::earcut( poly );
    R_xlen_t n_triangles = indices.length() / 3;

    Rcpp::NumericVector x = df["x"];
    Rcpp::NumericVector y = df["y"];
    Rcpp::NumericVector xx = x[ indices ];
    Rcpp::NumericVector yy = y[ indices ];

    Rcpp::IntegerVector triangle_idx = Rcpp::seq(1, n_triangles );
    Rcpp::IntegerVector triangle_ids = Rcpp::rep_each( triangle_idx, 3 );

    Rcpp::DataFrame df_tri = Rcpp::DataFrame::create(
      Rcpp::_["triangle_id"] = triangle_ids,
      Rcpp::_["x"] = xx,
      Rcpp::_["y"] = yy
    );

    Rcpp::StringVector geometry_cols {"x","y"};
    Rcpp::String polygon_id = "triangle_id";
    Rcpp::String line_id = polygon_id;

    std::string xyzm = "XY";
    bool close = false;

    res[ i ] = sfheaders::sfg::sfg_multipolygon( df_tri, geometry_cols, polygon_id, line_id, xyzm, close );

  }

  sfheaders::sfc::attach_sfc_attributes( res, attributes );

  return res;

}
