/*
 * This is a basic boot file for a bare bones operating system.
 * It sets up a multiboot header, a stack, and the entry point for the kernel.
 * The multiboot header is used by the GRUB bootloader to know how to load the OS.
 * The stack is used for function calls within the OS.
 * The entry point, _start, sets up the stack pointer and then jumps to the kernel's main function.
 * After the kernel's main function returns (if it does), it disables interrupts and halts the CPU.
 *
 * This file is based on the Bare Bones tutorial on the OSDev Wiki.
 * You can find the original tutorial at https://wiki.osdev.org/Bare_Bones
 */

/* multiboot header. */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/* Stack setup */
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

.section .text
.global _start
.type _start, @function
_start:
	mov $stack_top, %esp # Set the stack pointer
	call kernel_main
	cli
1:	hlt
	jmp 1b

.size _start, . - _start
