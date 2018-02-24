#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP _dopey_cpp_dopey(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"_dopey_cpp_dopey", (DL_FUNC) &_dopey_cpp_dopey, 2},
    {NULL, NULL, 0}
};

void R_init_dopey_cpp(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
