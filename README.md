ARM Run-Time ABI for the Cortex-M0 processor
============================================

This library implements the Run-Time ABI for the ARM architecture as defined
in document ARM IHI 0043C (http://infocenter.arm.com) for the Thumb-2 ISA
subset of the Cortex-M0.

So Far Implemented
------------------

~~~~
__aeabi_lmul()
__aeabi_uidiv()
__aeabi_uidivmod()
__aeabi_uldivmod()
~~~~

Additional libgcc wrapper functions
-----------------------------------
Ironically they are not needed for gcc, which uses the aeabi functions, but for
LLVM.

~~~~
__muldi3()
__umodsi3():
__udivsi3():
__umoddi3():
__udivdi3():
~~~~


License
-------

Licensed under the ISC licence (similar to the MIT/Expat license).
