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



@ int __aeabi_fcmpeq(float r0, float r1)
@
@ Return 1 if r0==r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmpeq
__aeabi_fcmpeq:

        push    {lr}
        bl      __aeabi_cfcmpeq
        bne     .Lreturn0
.Lreturn1:
        movs    r0, #1
        pop     {pc}




@ int __aeabi_fcmplt(float r0, float r1)
@
@ Return 1 if r0<r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmplt
__aeabi_fcmplt:

        push    {lr}
        bl      __aeabi_cfcmple
        blo     .Lreturn1
.Lreturn0:
        movs    r0, #0
        pop     {pc}



@ int __aeabi_fcmple(float r0, float r1)
@
@ Return 1 if r0<=r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmple
__aeabi_fcmple:

        push    {lr}
        bl      __aeabi_cfcmple
        bls     .Lreturn1
        movs    r0, #0
        pop     {pc}



@ int __aeabi_fcmpge(float r0, float r1)
@
@ Return 1 if r0>=r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmpge
__aeabi_fcmpge:

        push    {lr}
        bl      __aeabi_cfrcmple
        bls     .Lreturn1
        movs    r0, #0
        pop     {pc}



@ int __aeabi_fcmpgt(float r0, float r1)
@
@ Return 1 if r0>r1 and no NaN, else 0
@
        .thumb_func
        .global __aeabi_fcmpgt
__aeabi_fcmpgt:

        push    {lr}
        bl      __aeabi_cfrcmple
        blo     .Lreturn1
        movs    r0, #0
        pop     {pc}
