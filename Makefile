AS=arm-none-eabi-as -mthumb
AR=arm-none-eabi-ar

SRC_FILES=$(wildcard *.S) 

%.o: %.S
	$(AS) $< -o $@

libaeabi-cortexm0.a: $(SRC_FILES:%.S=%.o)
	$(AR) rcs libaeabi-cortexm0.a $(SRC_FILES:%.S=%.o)



.PHONY: all clean

all: libaeabi-cortexm0.a

clean:
	-rm -f *.o *.a
