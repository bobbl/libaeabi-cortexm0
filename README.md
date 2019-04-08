ARM Run-Time ABI for the Cortex-M0 processor
============================================

This library implements the Run-time ABI for the ARM architecture as defined in
document [ARM IHI 0043C](infocenter.arm.com/help/topic/com.arm.doc.ihi0043d/IHI0043D_rtabi.pdf)
for the Thumb-2 ISA subset of the Cortex-M0.


So Far Implemented
------------------

~~~~
__aeabi_lmul()
__aeabi_ldivmod()
__aeabi_uldivmod()
__aeabi_llsl()
__aeabi_llsr()
__aeabi_lasr()
__aeabi_lcmp()
__aeabi_ulcmp()
__aeabi_idiv()
__aeabi_uidiv()
__aeabi_idivmod()
__aeabi_uidivmod()
__aeabi_uread4()
__aeabi_uwrite4()
__aeabi_uread8()
__aeabi_uwrite8()
__aeabi_memcpy8()
__aeabi_memcpy4()
__aeabi_memcpy()
__aeabi_memmove8()
__aeabi_memmove4()
__aeabi_memmove()
__aeabi_memset8()
__aeabi_memset4()
__aeabi_memset()
__aeabi_memclr8()
__aeabi_memclr4()
__aeabi_memclr()
~~~~


Additional libgcc wrapper functions
-----------------------------------
Older LLVM versions required them, now LLVM also uses the ARM EABI, therefore
these wrappers will be removed soon.

~~~~
__muldi3()
__moddi3()
__divdi3()
__umoddi3()
__udivdi3()
__ashldi3()
__lshrdi3()
__ashrdi3()
__modsi3()
__divsi3()
__umodsi3()
__udivsi3()
~~~~



Cross compiling
---------------

### GNU binutils / gcc

Ubuntu provides the package `gcc-arm-none-eabi` with the ARM cross compiler
based on gcc. To cross compile for the ARM Cortex-M0 use

    arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -o foo.arm foo.c -nostdlib -laeabi-cortexm0

### clang / LLVM

Clang is a native cross compiler, but the standard linker `/usr/bin/ld` is not
able to link ARM binaries. Therefore use LLD (ubuntu package `lld-7`):

    clang -target armv6m-none-eabi -fuse-ld=lld-7 -o foo.arm foo.c -nostdlib -laeabi-cortexm0


License
-------
Licensed under the ISC licence (similar to the MIT/Expat license).
