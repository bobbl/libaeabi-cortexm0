@ Runtime ABI for the ARM Cortex-M0
@ nonan_fcmpeq.S: softfloat equality comparison ignoring NaNs
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



@ int __aeabi_fcmpeq(float r0, float r1)
@
@ Return 1 if r0==r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmpeq
__aeabi_fcmpeq:

        mov     r2, r0          @ special case +0 == -0
        orrs    r2, r1
        lsls    r2, #1
        beq     1f
        cmp     r0, r1
        beq     1f
        movs    r0, #0
        bx      lr

1:      movs    r0, #1
        bx      lr
