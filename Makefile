all: smap_support smap_mod.ko

smap_support: smap_support.asm
	nasm -f elf64 $^ -o smap_support.o
	gcc -s -o smap_support smap_support.o

obj-m += smap.o
smap-objs := smap_mod.o read_cr4_smap.o test_write.o

smap_mod.ko: smap_mod.c
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

$(KBUILD_EXTMOD)/%.o: %.asm
	nasm -f elf64 -o $@ $^

clean:
	@ rm -rf *.o
	@ rm -rf smap_support
	@ make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
