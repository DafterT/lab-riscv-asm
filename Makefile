C_DIR    := c_prog

# файлы для Си
C_SRC      := $(C_DIR)/main.c
C_BIN      := $(C_DIR)/c_prog.out
RISCV_SRC  := $(C_SRC)
RISCV_ELF  := $(C_DIR)/asm_prog.efi
RISCV_DUMP := $(C_DIR)/asm_prog.dump

# инструменты
CC_NATIVE := gcc
CC_RISCV  := riscv64-unknown-elf-gcc
OBJDUMP   := riscv64-unknown-elf-objdump

CFLAGS_RISCV := -march=rv32i -mabi=ilp32

.PHONY: all native riscv dump clean

all: clean native riscv dump

native: $(C_BIN)

$(C_BIN): $(C_SRC)
	$(CC_NATIVE) $< -o $@

riscv: $(RISCV_ELF)

$(RISCV_ELF): $(RISCV_SRC)
	$(CC_RISCV) $(CFLAGS_RISCV) $< -o $@

dump: $(RISCV_DUMP)

$(RISCV_DUMP): $(RISCV_ELF)
	$(OBJDUMP) -D $< > $@

clean:
	rm -f $(C_BIN) $(RISCV_ELF) $(RISCV_DUMP)
