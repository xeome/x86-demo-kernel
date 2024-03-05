AS = i686-elf-as
CC = i686-elf-gcc
LD = i686-elf-gcc

CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -ffreestanding -O2 -nostdlib -T linker.ld

OBJS = boot.o kernel.o

BUILD_DIR = build

OUTPUT = $(BUILD_DIR)/myos.bin
ISO = $(BUILD_DIR)/myos.iso

ISODIR = isodir/boot/grub

all: $(ISO)

$(ISO): $(OUTPUT)
	mkdir -p $(ISODIR)
	cp $(OUTPUT) $(ISODIR)/../myos.bin
	cp grub.cfg $(ISODIR)/grub.cfg
	grub-mkrescue -o $(ISO) isodir

$(OUTPUT): $(addprefix $(BUILD_DIR)/, $(OBJS))
	$(LD) $(LDFLAGS) -o $(OUTPUT) $(addprefix $(BUILD_DIR)/, $(OBJS)) -lgcc

$(BUILD_DIR)/boot.o: boot.s
	mkdir -p $(BUILD_DIR)
	$(AS) boot.s -o $(BUILD_DIR)/boot.o

$(BUILD_DIR)/kernel.o: kernel.c
	mkdir -p $(BUILD_DIR)
	$(CC) -c kernel.c -o $(BUILD_DIR)/kernel.o $(CFLAGS)

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

clean:
	rm -f $(OBJS) $(OUTPUT) $(ISO)
	rm -rf isodir
	rm -rf $(BUILD_DIR)
