ASM_SRC := asm_64/

all: smap_support smep_support testeap.ko 

%.o: $(ASM_SRC)%.asm
	nasm -f elf64 $^ -o $@

smap_support: smap_support.o cpu_feature.o
	ld -s -o $@ $^

smep_support: smep_support.o cpu_feature.o
	ld -s -o $@ $^

obj-m += testeap.o
testeap-objs := testeap_mod.o read_cr4.o test_write.o cpu_feature.o

testeap.ko: testeap_mod.c
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	@ rm -rf *.o
	@ rm -rf smap_support
	@ rm -rf smep_support
	@ make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
