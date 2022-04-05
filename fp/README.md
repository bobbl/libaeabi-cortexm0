Floating Point Helper Functions
-------------------------------

### Floating Point Comparison

In the Runtime ABI for ARM, the support for NaNs is optional. Therefore
an implementation with support and a faster one without NaN support is
provided.

The floating point compare functions can be divided in two subsets by the way
how the result is returned: either via the PSR flags Z and C or via a boolean 
value in r0.

The first group consists of 3 functions. Ignoring quiet NaNs, `__aeabi__cfcmpeq`
and `__aeabi_cfcmple` are identical and `__aeabi_cfrcmple` simply swaps the
arguments before the comparison. So basically there is only one function that
sets Z if a==b and clears C if a<b. If any argument is NaN, C=1 and Z=0 is
returned. The unsigned branch instructions can be used to deal with the result:

| instruction | branch if                                       |
| ----------- | ----------------------------------------------- |
| beq         | (r0 == r1) and no NaN                           |
| blo         | (r0 < r1) and no NaN                            |
| bls         | (r0 <= r1) and no NaN                           |
| bne         | (r0 != r1) or one is a NaN (not equal)          |
| bhi         | (r0 > r1) or one is a NaN (not lower or equal)  |
| bhs         | (r0 >= r1) or one is a NaN (not lower)          |

The other group of functions checks a certain relation: =, <, <=, >= > and
returns true (1) or false (0) in r0.

One group suffices to do all possible comparisons. Therefore a compiler
should normally only use one of the two groups.

On the other hand, a trivial implementation of the single comparisons is a
call to the flag delivering comparison and a branch that returns 0 or 1. The
implementation with NaN support uses this trivial approach, because the NaN
checks are quite expensive.

In the non-NaN implementation, the single comparisons are standalone functions
that do not depend on `__aeabi_cfcmple`. Nevertheless, the 3 flag-functions are
provided to fulfil the standard requirements. But gcc for example does not
directly use it and therefore they are not linked.

The same applies to `__aeabi_fcmpun` which tests, if the arguments are NaNs.
Although the function is needless if NaNs are not supported, it is provided
as a function without dependencies that likely won't be used.
