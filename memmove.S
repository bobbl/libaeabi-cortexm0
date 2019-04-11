/* Runtime ABI for the ARM Cortex-M0  
 * memmove.S: move memory block
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



@ void __aeabi_memmove8(void *r0, const void *r1, size_t r2);
@
@ Move r2 bytes from r1 to r0 and check for overlap.
@ r1 and r0 must be aligned to 8 bytes.
@
	.thumb_func
	.global __aeabi_memmove8
__aeabi_memmove8:



@ void __aeabi_memmove4(void *r0, const void *r1, size_t r2);
@
@ Move r2 bytes from r1 to r0 and check for overlap.
@ r1 and r0 must be aligned to 4 bytes.
@
	.thumb_func
	.global __aeabi_memmove4
__aeabi_memmove4:



	cmp	r0, r1
	bls	__aeabi_memcpy4
	adds	r3, r1, r2
	cmp	r0, r3
	bhs	__aeabi_memcpy4

	b	.Lbackward_entry

.Lbackward_loop:
	ldrb	r3, [r1, r2]
	strb	r3, [r0, r2]

.Lbackward_entry:
	subs	r2, #1
	bhs	.Lbackward_loop

	bx	lr



@ void __aeabi_memmove(void *r0, const void *r1, size_t r2);
@
@ Move r2 bytes from r1 to r0 and check for overlap.
@ r0 and r1 need not be aligned.
@
	.thumb_func
	.global __aeabi_memmove
__aeabi_memmove:



	cmp	r0, r1
	bls	__aeabi_memcpy
	adds	r3, r1, r2
	cmp	r0, r3
	blo	.Lbackward_entry



@ void __aeabi_memcpy(void *r0, const void *r1, size_t r2);
@
@ Move r2 bytes from r1 to r0. No overlap allowed.
@ r0 and r1 need not be aligned.
@
	.thumb_func
	.global __aeabi_memcpy
__aeabi_memcpy:



	cmp	r2, #8
	blo	.Lforward1
	mov	r3, r0
	eors	r3, r1
	lsls	r3, r3, #30
	bne	.Lforward1

	lsrs	r3, r0, #1
	bcc	.Lalign2
	ldrb	r3, [r1]
	strb	r3, [r0]
	adds	r0, #1
	adds	r1, #1
	subs	r2, #1
.Lalign2:
	lsrs	r3, r0, #2
	bcc	.Lalign4
	ldrh	r3, [r1]
	strh	r3, [r0]
	adds	r0, #2
	adds	r1, #2
	subs	r2, #2
.Lalign4:



@ void __aeabi_memcpy8(void *r0, const void *r1, size_t r2);
@
@ Move r2 bytes from r1 to r0. No overlap allowed.
@ r0 and r1 must be aligned to 8 bytes.
@
	.thumb_func
	.global __aeabi_memcpy8
__aeabi_memcpy8:



@ void __aeabi_memcpy4(void *r0, const void *r1, size_t r2);
@
@ Move r2 bytes from r1 to r0. No overlap allowed.
@ r0 and r1 must be aligned to 4 bytes.
@
	.thumb_func
	.global __aeabi_memcpy4
__aeabi_memcpy4:



	subs	r2, #20
	blo	.Lforward4
	push	{r4, r5, r6, r7}
.Lforward20_loop:
	ldm	r1!, {r3, r4, r5, r6, r7}
	stm	r0!, {r3, r4, r5, r6, r7}
	subs	r2, #20
	bhs	.Lforward20_loop
	pop	{r4, r5, r6, r7}

.Lforward4:
	adds	r2, #16
	blo	.Lforward4_corr
.Lforward4_loop:
	ldm	r1!, {r3}
	stm	r0!, {r3}
	subs	r2, #4
	bhs	.Lforward4_loop

.Lforward4_corr:
	adds	r2, #4

.Lforward1:
	orrs	r2, r2
	beq	9f
	push	{r4}
	eors	r4, r4

.Lforward1_loop:
	ldrb	r3, [r1, r4]
	strb	r3, [r0, r4]
	adds	r4, #1
	cmp	r4, r2
	blo	.Lforward1_loop
	pop	{r4}
9:	bx	lr
