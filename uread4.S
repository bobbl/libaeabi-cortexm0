/* Runtime ABI for the ARM Cortex-M0  
 * uread4.S: unaligned memory read
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



@ int __aeabi_uread4(void *r0)
@
@ Read 4 little endian bytes from unaligned memory address
@
	.thumb_func
	.global __aeabi_uread4
__aeabi_uread4:


	lsls	r1, r0, #30
	lsrs	r1, r1, #27	@ r1 = bit offset relative to aligned address
	lsrs	r0, r0, #2
	lsls	r0, r0, #2	@ r0 = round down address
	ldm	r0, {r0,r2}	@ r2:r0 = 8 bytes including the unaligned word
	lsrs	r0, r1
	subs	r1, #32
	negs	r1, r1
	lsls	r2, r1
	orrs	r0, r2		@ r0 = (r0>>r1) | (r2<<(32-r1))
	bx	lr
