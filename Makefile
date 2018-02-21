ASM_SRC := asm_64/


all: smap_support smap_mod.ko smep_support

%.o: $(ASM_SRC)%.asm
	nasm -f elf64 $^ -o $@

smap_support: smap_support.o cpu_feature.o
	ld -s -o $@ $^

smep_support: smep_support.o cpu_feature.o
	ld -s -o $@ $^

obj-m += smap.o
smap-objs := smap_mod.o read_cr4.o test_write.o cpu_feature.o

smap_mod.ko: smap_mod.c
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

$(KBUILD_EXTMOD)/%.o: %.asm
	nasm -f elf64 -o $@ $^

clean:
	@ rm -rf *.o
	@ rm -rf smap_support
	@ make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	@ rm -rf smep_support
