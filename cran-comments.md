# decido 0.5.0

Two things in this release.

1. The vendored copy of 'earcut.hpp' has been updated from a January 2020
   snapshot to mapbox/earcut.hpp commit f25bc76. The public entry
   point mapbox::earcut<N>() is unchanged, so the package bindings and the
   headers in inst/include/decido are unchanged.

   The exact triangulation index returned by earcut() differs from decido
   0.4.0 for some inputs. Hard-coded expectations in the package tests have
   been regenerated. 

2. structure() calls in the tests no longer use the .Dim and .Dimnames
   substitute attribute names, which are deprecated as of R 4.7.0.

earcut() also gains an optional 'refine' argument, off by default, exposing
the Delaunay post-pass added upstream.

## Test environments

* local, R release
* GitHub Actions: windows-latest (release), macOS-latest (release),
  ubuntu-latest (release, oldrel, devel)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

Checked all four reverse dependencies: raybevel, rayrender and silicate
(Imports) and eplusr (Suggests). All of them call only the exported
earcut() function, and none depend on the exact index ordering. No problems
found.

Maintainers of the three Imports packages were notified of the changed
index output ahead of this submission.
