#ifndef R_DECIDO_EARCUT_H
#define R_DECIDO_EARCUT_H

#include <RcppCommon.h>
#include <array>
#include "earcut.h"


namespace Rcpp {

  template < typename T > SEXP wrap( std::array< T, 2 >& Point );
  template < typename T > SEXP wrap( std::vector< std::array< T, 2 > >& Polygon );
  template < typename T > SEXP wrap( std::vector< std::vector< std::array< T, 2 > > >& Polygons );

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
  SEXP wrap( std::vector< std::vector< std::array< T, 2 > > >& Polygons ) {
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
      if( vec.length() != 2 ) {
        Rcpp::stop("decido - each point in the polygon must have exactly two coordinates");
      }
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
        if( !Rf_isMatrix( lst[ i ] ) ) {
          Rcpp::stop("decido - a list must only contain matrices");
        }
        Rcpp::Matrix< RTYPE > mat = lst[ i ];
        x[i] = Rcpp::as< std::vector< std::array< T, 2 > > >( mat );
      }
      return x;
    }
  };

} // traits
} // Rcpp

typedef double Coord;
typedef std::array< Coord, 2 > Point;
typedef std::vector< Point > Polygon;
typedef std::vector< Polygon > Polygons;

namespace decido {
namespace api {

  inline Rcpp::IntegerVector earcut(
    Rcpp::NumericVector& x,
    Rcpp::NumericVector& y,
    IntegerVector& holes,
    IntegerVector& numholes
  ) {
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

  inline Rcpp::IntegerVector earcut(
      SEXP& polygon
  ) {
    if( TYPEOF( polygon ) != VECSXP ) {
      Rcpp::stop("decido - expecting a list of matrices");
    }
    Polygons polyrings = Rcpp::as< Polygons >( polygon );
    std::vector< uint32_t > indices = mapbox::earcut< uint32_t >( polyrings );
    return Rcpp::wrap( indices );
  }

} // earcut
} // decido


#endif
