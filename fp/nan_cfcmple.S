@ Runtime ABI for the ARM Cortex-M0
@ nan_cfcmple.S: softfloat comparison to flags with NaN support
@
@ Copyright Jörg Mische <bobbl@gmx.de>
@
@ Permission to use, copy, modify, and/or distribute this software for any
@ purpose with or without fee is hereby granted, provided that the above
@ copyright notice and this permission notice appear in all copies.
@
@ THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
@ WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
@ MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
@ ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
@ WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
@ ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
@ OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
@
@ SPDX-License-Identifier: ISC



        .syntax unified
        .text
        .thumb
        .cpu cortex-m0



@ int __aeabi_cfrcmple(float a:r0, float b:r1)
@
@ Compare IEEE binary32 floats and return C=0 if greater, Z=1 if equal.
@ If any float is a NaN, return C=1 and Z=0.
@
        .thumb_func
        .global __aeabi_cfrcmple
__aeabi_cfrcmple:
        mov     r2, r0          @ swap r0 and r1 and
        mov     r0, r1          @ fallthrough to __aeabi_cfcmple()
        mov     r1, r2



@ int __aeabi_cfcmpeq(float a:r0, float b:r1)
@
@ same as __aeabi_cfcmple()
@
        .thumb_func
        .global __aeabi_cfcmpeq
__aeabi_cfcmpeq:



@ int __aeabi_cfcmple(float a:r0, float b:r1)
@
@ Compare IEEE binary32 floats and return C=0 if lower, Z=1 if equal.
@ If any float is a NaN, return C=1 and Z=0.
@
@ The caller must use branches to process the result:
@   beq   branch if (r0 == r1) and no NaN
@   blo   branch if (r0 < r1) and no NaN
@   bls   branch if (r0 <= r1) and no NaN
@   bne   branch if (r0 != r1) or one is a NaN (not equal)
@   bhi   branch if (r0 > r1) or one is a NaN (not lower or equal)
@   bhs   branch if (r0 >= r1) or one is a NaN (not lower)
@
        .thumb_func
        .global __aeabi_cfcmple
__aeabi_cfcmple:

        lsls    r2, r0, #1
        lsrs    r2, #24
        cmp     r2, #255
        beq     .La_inf_or_nan

.Lcheck_b:
        lsls    r2, r1, #1
        lsrs    r2, #24
        cmp     r2, #255
        beq     .Lb_inf_or_nan

.Lcmp_signs:
        mov     r2, r0
        eors    r2, r1
        bpl     .Lsame_sign

        @ Opposite signs, therefore the positive one is larger

        @ Special case: +0 and -0 are equal
        @ iff comparing +0 and -0
        @   a|b == a|(a^b) == 8000'0000'hex
        @   after shift:
        @     C=1 (most signfificant bit)
        @     Z=1 (remainig bits all 0)
        @   => flags correctly set, exit
        orrs    r2, r0          @ does not care if a|b or a|(a^b)
        lsls    r2, #1
        beq     .Lret

        @ two cases: a positive and b negative or vice versa
        @ Z=0 (at least sign bit differs)
        @ C=0 if a negative, C=1 if a positive
.Lboth_neg:
        cmp     r1, r0
.Lret:
        bx      lr

.Lsame_sign:
        cmp     r0, #0
        bmi     .Lboth_neg
        cmp     r0, r1          @ compare to set flags
        bx      lr

.La_inf_or_nan:
        lsls    r2, r0, #9
        beq     .Lcheck_b       @ a is inf => continue

        @ Z = 0 (after beq)
        @ C = bit 23 of r0 = 1 (lowest bit of all-set NaN exponent)
        @ => flags correctly set to indicate unordered result
        bx      lr

.Lb_inf_or_nan:
        lsls    r2, r1, #9
        beq     .Lcmp_signs     @ b is inf and a not NaN => compare

        @ Z = 0 (after beq)
        @ C = bit 23 of r1 = 1 (lowest bit of all-set NaN exponent)
        @ => flags correctly set to indicate unordered result
        bx      lr
