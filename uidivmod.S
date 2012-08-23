/* This is the ISC license (similar to the MIT/Expat license)
 *
 * Copyright (c) 2011 Jörg Mische <bobbl@gmx.de>
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
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/* Runtime ABI for the ARM Cortex-M0  
 * uidivmod.S: unsigned 32 bit division
 */



	.syntax unified
	.text
	.thumb



/* __aeabi_uidivmod()
 *
 * Input:  r0 = numerator
 *         r1 = denominator
 * Output: r0 = quotient
 *         r1 = remainder
 */
	.thumb_func
        .global __aeabi_uidivmod
__aeabi_uidivmod:


	cmp	r1, #0
	bne	L_no_div0
	b	__aeabi_idiv0
L_no_div0:

	// Shift left the denominator until it is greater than the numerator
	movs	r2, #0		// counter
	cmp	r0, r1
	bls	L_denom_greater
	adds	r1, #0		// dont shift if denominator would overflow
	bmi	L_denom_greater
	
L_denom_shift_loop:
	adds	r2, #1
	lsls	r1, #1
	bmi	L_denom_greater
	cmp	r0, r1
	bhi	L_denom_shift_loop	
	
L_denom_greater:
	movs	r3, #1
	lsls	r3, r2
	movs	r2, #0
	
L_sub_loop0:	
	cmp	r0, r1
	bcc	L_dont_subtract0	// if (num>denom)

	subs	r0, r1		// numerator -= denom
	orrs	r2, r3		// result(r7:r6) |= bitmask(r5)
L_dont_subtract0:

	lsrs	r1, #1		// denom(r3:r2) >>= 1
	lsrs	r3, #1		// bitmask(r5) >>= 1
	bne	L_sub_loop0

	mov	r1, r0		// remainder(r3:r2) = numerator(r1:r0)
	mov	r0, r2		// quotient(r1:r0) = result(r7:r6)

	bx	lr
