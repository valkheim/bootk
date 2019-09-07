all: bootloader kernel
	gcc -m32 -march=i386 -T linker.ld -o os.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

bootloader:
	as --32 boot.s -o boot.o

kernel:
	gcc -m32 -march=i386 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

iso: all
	@mkdir -p isodir/boot/grub
	cp os.bin isodir/boot/os.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o os.iso isodir

test: iso
	qemu-system-i386 -cdrom os.iso
