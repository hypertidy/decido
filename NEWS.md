# decido 0.0.1

* Added helper functions `plot_holes` and `plot_ears` to wrap calls to polypath for polygon plot and
 triangle plot respectively, using the same style as function `earcut`. 
 
* Modified to use 1-based indexing always at R level, and wrapped internal function earcut_cpp with
 R level `earcut` with checks on inputs. 
 
* Removed need for `numholes` argument. 

* Fixed immense logic bug, not sure how it was working at all before. 

* Fixed file naming and declarations, thanks to Andrew Smith. 

* Added support for holes via `earcut(x, y, holes = , numholes = )`.

* First implementation from basic template. 
