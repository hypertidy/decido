#ifndef R_DECIDO_EARCUT_H
#define R_DECIDO_EARCUT_H

#include <RcppCommon.h>

#include "earcut.h"


namespace Rcpp {

  template < typename T > SEXP wrap( std::array< T, 2 >& Point );
  template < typename T > SEXP wrap( std::vector< std::array< T, 2 > >& Polygon );
  template < typename T > SEXP wrap( std::vector< std::vector< std::array< T, 2 > > > Polygons );

namespace traits {

  template < typename T > class Exporter< std::array< T, 2 > >;
  template < typename T > class Exporter< std::vector< std::array< T, 2 > > >;
  template < typename T > class Exporter< std::vector< std::vector< std::array< T, 2 > > > >;

} // traits
} // Rcpp

#include <Rcpp.h>

namespace Rcpp {

  template <typename T>
  SEXP wrap( std::array< T, 2 >& Point ) {
    Rcpp::NumericVector v(2);
    v[0] = Point[0];
    v[1] = Point[1];
    return v;
  }

  template < typename T >
  SEXP wrap( std::vector< std::array< T, 2 > >& Polygon ) {
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

  template < typename T >
  SEXP wrap( std::vector< std::vector< std::array< T, 2 > > > Polygons ) {
    R_xlen_t n = Polygons.size();
    Rcpp::List lst( n );
    R_xlen_t i;
    for( i = 0; i < n; ++i ) {
      std::vector< std::array< T, 2 > > polygon = Polygons[ i ];
      lst[ i ] = Rcpp::wrap( polygon );
    }
    return lst;
  }

namespace traits {

  template < typename T > class Exporter< std::array< T, 2 > > {
    typedef typename std::array< T, 2 > Point;

    const static int RTYPE = Rcpp::traits::r_sexptype_traits< T >::rtype;
    Rcpp::Vector< RTYPE > vec;

  public:
    Exporter( SEXP x ) : vec( x ) {
      if( TYPEOF( x ) != RTYPE ) {
        throw std::invalid_argument("decido - invalid R object for creating a Point");
      }
    }

    Point get() {
      Point x({ vec[0], vec[1] });
      return x;
    }

  };

  template < typename T > class Exporter< std::vector< std::array< T, 2 > > > {
    typedef typename std::vector< std::array< T, 2 > > Polygon;

    const static int RTYPE = Rcpp::traits::r_sexptype_traits< T >::rtype;
    Rcpp::Matrix< RTYPE > mat;

  public:
    Exporter( SEXP x ) : mat( x ) {
      if( TYPEOF( x ) != RTYPE ) {
        throw std::invalid_argument("decido - invalid R object for creating a Polygon");
      }
    }

    Polygon get() {
      R_xlen_t n_row = mat.nrow();
      Polygon x( n_row );
      R_xlen_t i;
      for( i = 0; i < n_row; ++i ) {
        Rcpp::Vector< RTYPE > v = mat( i, Rcpp::_);
        x[i] = Rcpp::as< std::array< T, 2 > >( v );
      }
      return x;
    }
  };

  template< typename T > class Exporter< std::vector< std::vector< std::array< T, 2 > > > > {
    typedef typename std::vector< std::vector< std::array< T, 2 > > > Polygons;

    const static int RTYPE = Rcpp::traits::r_sexptype_traits< T >::rtype;
    Rcpp::List lst;

  public:
    Exporter( SEXP x ) : lst( x ) { }
    Polygons get() {
      R_xlen_t n = lst.size();
      Polygons x( n );
      R_xlen_t i;
      for( i = 0; i < n; ++i ) {
        Rcpp::Matrix< RTYPE > mat = lst[ i ];
        x[i] = Rcpp::as< std::vector< std::array< T, 2 > > >( mat );
      }
      return x;
    }
  };

} // traits
} // Rcpp

namespace decido {
namespace earcut {


} // earcut
} // decido


#endif
