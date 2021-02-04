@ Runtime ABI for the ARM Cortex-M0
@ nonan_fcmplt.S: softfloat lower comparison ignoring NaNs
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



@ int __aeabi_fcmpgt(float r0, float r1)
@
@ Return 1 if r0>r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmpgt
__aeabi_fcmpgt:

        mov     r2, r0          @ swap r0 and r1
        mov     r0, r1
        mov     r1, r2
        @ fallthrough to  __aeabi_fcmplt



@ int __aeabi_fcmplt(float r0, float r1)
@
@ Return 1 if r0<r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmplt
__aeabi_fcmplt:

        mov     r2, r0
        eors    r2, r1
        bpl     3f

        @ opposite signs, therefore the positive one is larger

        @ special case: +0 and -0 are equal
        orrs    r2, r0          @ does not care if a|b or a|(a^b)
        lsls    r2, #1
        beq     .Lret0

        @ two cases: a positive and b negative or vice versa
.Ltrue_if_b_lower:
        cmp     r1, r0
        blo     .Lret1
.Lret0:
        movs    r0, #0
        bx      lr

3:      @ same sign
        cmp     r0, #0
        bmi     .Ltrue_if_b_lower

        cmp     r0, r1
        bhs     .Lret0
.Lret1:
        movs    r0, #1
        bx      lr
