default: build

.PHONY: default build run clean

build/multiboot_header.o: kernel/arch/x86_64/multiboot_header.asm
	mkdir -p build
	nasm -f elf64 kernel/arch/x86_64/multiboot_header.asm -o build/multiboot_header.o

build/boot.o: kernel/arch/x86_64/boot.asm
	mkdir -p build
	nasm -f elf64 kernel/arch/x86_64/boot.asm -o build/boot.o

build/kernel.o:
	mkdir -p build
	x86_64-elf-gcc -ffreestanding -Wall -Wextra -O2 -nostdlib -lgcc -c kernel/kernel/kernel.c -o build/kernel.o

build/kernel.bin: build/multiboot_header.o build/boot.o build/kernel.o
	ld -n -o build/kernel.bin -T linker.ld build/multiboot_header.o build/boot.o build/kernel.o

build/os.iso: build/kernel.bin grub.cfg
	mkdir -p build/isofiles/boot/grub
	cp grub.cfg build/isofiles/boot/grub
	cp build/kernel.bin build/isofiles/boot/
	grub-mkrescue -o build/os.iso build/isofiles

build: build/os.iso

run: build/os.iso
	qemu-system-x86_64 -cdrom build/os.iso

clean:
	rm -rf build