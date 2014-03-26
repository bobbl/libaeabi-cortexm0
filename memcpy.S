/* Runtime ABI for the ARM Cortex-M0  
 * memcpy.S: copy memory region
 *
 * Copyright (c) 2014 Mario Werner <nioshd@gmail.com>
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

@ void __aeabi_memcpy(void *r0, const void *r1, size_t r2)
@
@ Copy the r2 bytes from with *r1 to *r0.
@
.thumb_func
.global __aeabi_memcpy
__aeabi_memcpy:


L_head:
  cmp r2, #0
  beq L_return

  ldrb  r3, [r1]
  strb  r3, [r0]
  adds  r0, #1
  adds  r1, #1
  subs  r2, #1
  b     L_head

L_return:
  bx    lr
