#ifndef R_DECIDO_EARCUT_H
#define R_DECIDO_EARCUT_H

#include <RcppCommon.h>

#include "earcut.h"


namespace Rcpp {
namespace traints {

  template < typename T > SEXP wrap( std::array< T, 2 >& Point );
  template < typename T > SEXP wrap( std::vector< std::array< T, 2 > >& Polygon );
  template < typename T > SEXP wrap( std::vector< std::vector< std::array< T, 2 > > > Polygons );

} // traits
} // Rcpp

#include <Rcpp.h>

namespace Rcpp {

  template <typename T> SEXP wrap( std::array< T, 2 >& Point ) {
    Rcpp::NumericVector v(2);
    v[0] = Point[0];
    v[1] = Point[1];
    return v;
  }

  template < typename T > SEXP wrap( std::vector< std::array< T, 2 > >& Polygon ) {
    R_xlen_t n = Polygon.size();
    Rcpp::NumericMatrix mat( n, 2 );
    R_xlen_t i;
    for( i = 0; i < n; ++i ) {
      std::array< T, 2 > pt =  Polygon[ i ];
      Rcpp::NumericVector nv = Rcpp::wrap( pt );
      mat( i, Rcpp::_ ) = nv;
    }
    return mat;
  }

  template < typename T > SEXP wrap( std::vector< std::vector< std::array< T, 2 > > > Polygons ) {
    R_xlen_t n = Polygons.size();
    Rcpp::List lst( n );
    R_xlen_t i;
    for( i = 0; i < n; ++i ) {
      std::vector< std::array< T, 2 > > polygon = Polygons[ i ];
      lst[ i ] = Rcpp::wrap( polygon );
    }
    return lst;
  }

} // Rcpp

namespace decido {
namespace earcut {


} // earcut
} // decido


#endif
