/* Runtime ABI for the ARM Cortex-M0  
 * lcmp.S: signed 64 bit comparison
 *
 * Copyright (c) 2017 Jörg Mische <bobbl@gmx.de>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
 * OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */



	.syntax unified
	.text
	.thumb
	.cpu cortex-m0



@ int __aeabi_lcmp(long long r1:r0, long long r3:r2)
@
@ Compare signed integers and return -1 if lower, 0 if equal or +1 if greater
@
	.thumb_func
	.global __aeabi_lcmp
__aeabi_lcmp:

	cmp	r1, r3
	blt	1f
	bgt	2f
	cmp	r0, r2
	bhi	2f
	sbcs	r0, r0, r0		@ 0 if cs and -1 if cc
	bx	lr
1:	movs	r0, #1
	rsbs	r0, r0, #0
	bx	lr
2:	movs	r0, #1
	bx	lr
