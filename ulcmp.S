/* Runtime ABI for the ARM Cortex-M0  
 * ulcmp.S: unsigned 64 bit comparison
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



@ int __aeabi_ulcmp(unsigned long long r1:r0, unsigned long long r3:r2)
@
@ Compare unsigned integers and return -1 if lower, 0 if equal or +1 if greater
@
	.thumb_func
	.global __aeabi_ulcmp
__aeabi_ulcmp:

	cmp	r1, r3
	blo	1f	@ cc
	bhi	2f
	cmp	r0, r2
	blo	1f
	bhi	2f
	eors	r0, r0
	bx	lr
1:	movs	r0, #1
	rsbs	r0, r0, #0
	bx	lr
2:	movs	r0, #1
	bx	lr


	cmp	r1, r3
	blo	1f
	bhi	2f
	cmp	r0, r2
	bhi	2f
1:	sbcs	r0, r0, r0		@ 0 if cs and -1 if cc
	bx	lr
2:	movs	r0, #1
	bx	lr
