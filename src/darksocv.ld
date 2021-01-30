MEMORY
{
    IO (rw!x) : ORIGIN = 0x80000000, LENGTH = 0x100
    MEM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x11990
}


ENTRY(boot)

SECTIONS
{
    .io :
    {
        io.o(COMMON)
    } > IO
    .text :
    {
        boot.o(.text);
        io.o(.text);
        stdio.o(.text);
        banner.o(.text);
        main.o(.text);
        tests/start.o(.text);
        *(.text);
        /*end = .;
		. = ALIGN(4);*/
    } > MEM
    .data :
    {
        *(.sbss)
        *(.rodata*)
        *(.data)
        *(.bss)
        *(.rela*)
        *(COMMON)
    } > MEM
}
