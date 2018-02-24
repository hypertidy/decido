#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP _decido_earcut(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"_decido_earcut", (DL_FUNC) &_decido_earcut, 2},
    {NULL, NULL, 0}
};

void R_init_decido(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
