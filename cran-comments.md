Hello, 

I believe decido 0.2.0 is now free of valgrind-visible problems. 

Apologies for the failure to fix before 2018-07-30, I was travelling at the time. 

Best regards, Mike

CRAN removal memory-access issue reported was

> showing memory-access errors under Fedora 28: see the
> 'Additional issues' linked from the packages's CRAN results page.
>
> Please correct ASAP and before Jul 30 to safely retain the package on CRAN"

## Resubmit version 0.2.0 after being archived

* Cleaned up Rcpp default arguments. 
* Fixed out of bounds code in Rcpp causing valgrind problems. 
* Ran valgrind tests locally and on R-hub. 
* Fixed unused oz import, replaced by Suggests. 

## Test environments

* local ubuntu, R 3.5.1
* ubuntu 14.04 (on travis-ci), R 3.5.0
* win-builder (devel and release)
* fedora-clang-devel and fedora-gcc-devel on r-hub

## R CMD check results

0 errors | 0 warnings | 0 notes


