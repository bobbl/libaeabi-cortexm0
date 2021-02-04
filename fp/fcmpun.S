@ Runtime ABI for the ARM Cortex-M0
@ fcmpun.S: softfloat test for NaNs
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



@ int __aeabi_fcmpun(float r0, float r1)
@
@ Return 1 if either r0 or r1 is NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmpun
__aeabi_fcmpun:

        lsls    r2, r0, #1
        lsrs    r2, #24
        cmp     r2, #255
        bne     1f
        lsls    r0, #9
        bne     3f              @ a.exp=255, a.mant!=0 => NaN

1:      lsls    r2, r1, #1
        lsrs    r2, #24
        cmp     r2, #255
        bne     2f
        lsls    r1, #9
        bne     3f              @ b.exp=255, b.mant!=0 => NaN

2:      movs    r0, #0
        bx      lr

3:      movs    r0, #1
        bx      lr


