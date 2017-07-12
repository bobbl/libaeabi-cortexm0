/* Runtime ABI for the ARM Cortex-M0  
 * uread8.S: unaligned memory read
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



@ long long __aeabi_uread8(void *r0)
@
@ Read 8 little endian bytes from unaligned memory address
@
	.thumb_func
	.global __aeabi_uread8
__aeabi_uread8:


	push	{r4}
	lsrs	r1, r0, #2
	lsls	r1, r1, #2
	lsls	r2, r0, #30
	lsrs	r2, r2, #27
	ldm	r1, {r0, r1, r3}
	lsrs	r0, r2
	mov	r4, r1
	lsrs	r1, r2
	subs	r2, #32
	negs	r2, r2
	lsls	r4, r2
	lsls	r3, r2
	orrs	r0, r4
	orrs	r1, r3 
	pop	{r4}
	bx	lr
