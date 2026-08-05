#!/bin/sh
# Re-vendor mapbox/earcut.hpp into decido. Run from the package root.
# Regenerates inst/include/earcut.h, inst/include/LICENSE and
# inst/include/mapbox-earcut.hpp.git.log.
set -e

PIN=f25bc765e3084583b7350080319c29ad87bf5857   # v3.2.3 + #133 + #134 + f917bfc

mkdir -p data-raw
cd data-raw
rm -rf earcut.hpp
git clone https://github.com/mapbox/earcut.hpp
cd earcut.hpp
git checkout --detach "$PIN"
git log -n 5 > ../../inst/include/mapbox-earcut.hpp.git.log
cd ../..

cp data-raw/earcut.hpp/include/mapbox/earcut.hpp inst/include/earcut.h
cp data-raw/earcut.hpp/LICENSE inst/include/LICENSE

# 0.5.0 drops the earcut.hold copy of the previous header; the version history
# is the record we need and it does not have to be installed for every user
rm -f inst/include/earcut.hold

Rscript data-raw/ascii-earcut.R

echo ""
echo "vendored header updated. next:"
echo "  Rscript -e 'Rcpp::compileAttributes()'"
echo "  Rscript -e 'devtools::document()'"
echo "  Rscript -e 'devtools::test()'"
