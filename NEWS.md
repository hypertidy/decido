# decido dev

* decido now registers the C Callable function `decido_earcut_cpp`, thanks to inspiration of @dcooley. 

# decido 0.2.0

* Increased automated test coverage of underlying library code. 

* Fixed a memory bug, thanks to CRAN checks. 

* Cleaned up some Rcpp defaults. 

* Updated readme. 

* Move oz to Suggests. 

# decido 0.1.0

* Modified description based on advice from CRAN. 

* `earcut` is now generic, with a default argument that operates on matrix, 
 list or data frame inputs - future extensions may dispatch on class of  single xy 
 argument.
 
* Breaking change, all R functions now have `xy` as first argument, no more
 `x` or `y` as separate vectors. xy maybe a matrix, a list, or a dataframe. 

# decido 0.0.1

* Added a vignette and more complete documentation. 

* Added helper functions `plot_holes` and `plot_ears` to wrap calls to polypath for polygon plot and
 triangle plot respectively, using the same style as function `earcut`. 
 
* Modified to use 1-based indexing always at R level, and wrapped internal function earcut_cpp with
 R level `earcut` with checks on inputs. 
 
* Removed need for `numholes` argument. 

* Fixed immense logic bug, not sure how it was working at all before. 

* Fixed file naming and declarations, thanks to Andrew Smith. 

* Added support for holes via `earcut(x, y, holes = , numholes = )`.

* First implementation from basic template. 
