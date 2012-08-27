AS=arm-none-eabi-as -mthumb

SRC_FILES=$(wildcard *.S) 

%.o: %.S
	$(AS) $< -o $@

libaeabi-cortexm0.a: $(SRC_FILES:%.S=%.o)
	ar rcs libaeabi-cortexm0.a $(SRC_FILES:%.S=%.o)



.PHONY: all clean

all: libaeabi-cortexm0.a

clean:
	-rm -f *.o *.a
