/* The bootloader will look at this image and start execution at the symbol
   designated at the entry point. */
ENTRY(start)

/* Tell where the various sections of the object files will be put in the final
   kernel image. */
SECTIONS
{
	. = 0xC0100000;

	/* First put the multiboot header, as it is required to be put very early
	   early in the image or the bootloader won't recognize the file format.
	   Next we'll put the .text section. */
	.text BLOCK(4K) : AT(ADDR(.text) - 0xC0000000)
	{
    code = .; _code = .; __code = .;
		*(.multiboot_header)
		*(.text)
	}

	/* Read-only data. */
	.rodata BLOCK(4K) : AT(ADDR(.rodata) - 0xC0000000)
	{
    rodata = .; _rodata = .; __rodata = .;
		*(.rodata)
	}

	/* Read-write data (initialized) */
	.data BLOCK(4K) : AT(ADDR(.data) - 0xC0000000)
	{
     data = .; _data = .; __data = .;
		*(.data)
	}

	/* Read-write data (uninitialized) and stack */
	.bss BLOCK(4K) : AT(ADDR(.bss) - 0xC0000000)
	{
    bss = .; _bss = .; __bss = .;
		*(COMMON)
		*(.bss)
	}

  end = .; _end = .; __end = .;

	/* The compiler may produce other sections, put them in the proper place in
	   in this file, if you'd like to include them in the final kernel. */
}
