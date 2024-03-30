DEFAULT_HOST!=../default-host.sh
HOST?=DEFAULT_HOST
HOSTARCH!=./target-triplet-to-arch.sh $(HOST)
ARCHDIR=arch/$(HOSTARCH)
NASM_FORMAT!=./nasm-format.sh $(HOSTARCH)

default: build

.PHONY: default build run clean

build/multiboot_header.o: kernel/arch/$(HOSTARCH)/multiboot_header.asm
	mkdir -p build
	nasm -f $(NASM_FORMAT) kernel/arch/$(HOSTARCH)/multiboot_header.asm -o build/multiboot_header.o

build/boot.o: kernel/arch/$(HOSTARCH)/boot.asm
	mkdir -p build
	nasm -f $(NASM_FORMAT) kernel/arch/$(HOSTARCH)/boot.asm -o build/boot.o

build/kernel.o:
	mkdir -p build
	$(HOSTARCH)-elf-gcc -ffreestanding -Wall -Wextra -O2 -nostdlib -lgcc -c kernel/kernel/kernel.c -o build/kernel.o

build/kernel.bin: build/multiboot_header.o build/boot.o build/kernel.o
	ld -n -o build/kernel.bin -T linker.ld build/multiboot_header.o build/boot.o build/kernel.o

build/os.iso: build/kernel.bin grub.cfg
	mkdir -p build/isofiles/boot/grub
	cp grub.cfg build/isofiles/boot/grub
	cp build/kernel.bin build/isofiles/boot/
	grub-mkrescue -o build/os.iso build/isofiles

build: build/os.iso

run: build/os.iso
	qemu-system-$(HOSTARCH) -cdrom build/os.iso

clean:
	rm -rf build