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
 * uldivmod.S: unsigned 64 bit division
 */



	.syntax unified
	.text
	.thumb



/* __aeabi_uldivmod()
 *
 * Input:  r1:r0 = numerator
 *         r3:r2 = denominator
 * Output: r1:r0 = quotient
 *         r3:r2 = remainder
 */
	.thumb_func
        .global __aeabi_uldivmod
__aeabi_uldivmod:
	
	cmp	r3, #0
	bne	L_really_64bit
	cmp	r2, #0
	beq	L_divison_by_0
	cmp	r1, #0
	bne	L_really_64bit
	
	// fallback to 32 bit version
	mov	r1, r2
	push	{lr}
	bl	__aeabi_uidivmod
	mov	r2, r1
	movs	r1, #0
	movs	r3, #0
	pop	{pc}

L_divison_by_0:
	b	__aeabi_ldiv0
	
L_really_64bit:
	push	{r4, r5, r6, r7, lr}


	// Shift left the denominator until it is greater than the numerator

	movs	r4, #0		// counter
	movs	r5, #0		// constant for adcs
	adds	r3, #0		// dont shift if denominator would overflow
	bmi	.denom_greater
	cmp	r1, r3
	bls	.hiword_greater
	
.denom_shift_loop:
	adds	r4, #1
	lsls	r3, #1
	lsls	r2, #1
	adcs	r3, r5		// r5=0
	bmi	.denom_greater	// dont shift if overflow
	cmp	r1, r3
	bhi	.denom_shift_loop	
	
.hiword_greater:
	bcc	.denom_greater
	cmp	r0, r2
	bls	.denom_greater
	
	adds	r4, #1
	lsls	r3, #1
	lsls	r2, #1
	adcs	r3, r5		// r5=0


.denom_greater:

	cmp	r4, #31
	bls	.small_result
	

// higher word of result
	
	subs	r4, #32
	movs	r5, #1
	lsls	r5, r4		// bit mask
	movs	r7, #0		// result

.sub_loop1:	
	mov	r4, r0
	cmp	r1, r3
	sbcs	r4, r2
	bcc	.dont_subtract1	// if (num>denom)

	subs	r1, r3		// num -= denom
	sbcs	r0, r2
	orrs	r7, r5		// result(r7:r6) |= bitmask(r5)
.dont_subtract1:

	lsls	r4, r3, #31	// denom(r3:r2) >>= 1
	lsrs	r2, #1
	lsrs	r3, #1
	orrs	r2, r4
	lsrs	r5, #1		// bitmask(r5) >>= 1
	bne	.sub_loop1
	
	movs	r4, #31


// lower word of result

.small_result:
	movs	r6, #0
	movs	r5, #1
	lsls	r5, r4
	
.sub_loop2:	
	mov	r4, r0
	cmp	r1, r3
	sbcs	r4, r2
	bcc	.dont_subtract2	// if (num>denom)

	subs	r1, r3		// numerator -= denom
	sbcs	r0, r2
	orrs	r6, r5		// result(r7:r6) |= bitmask(r5)
.dont_subtract2:

	lsls	r6, r3, #31	// denom(r3:r2) >>= 1
	lsrs	r2, #1
	lsrs	r3, #1
	orrs	r2, r6
	lsrs	r5, #1		// bitmask(r5) >>= 1
	bne	.sub_loop2

	mov	r3, r1		// remainder(r3:r2) = numerator(r1:r0)
	mov	r2, r0
	mov	r1, r7		// quotient(r1:r0) = result(r7:r6)
	mov	r0, r6

	pop	{r4, r5, r6, r7, pc}

