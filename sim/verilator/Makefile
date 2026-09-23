VERILATOR = verilator
TOP = soc_top
RTL_DIR = ../../rtl
PICORV32 = ../../third_party/picorv32/picorv32.v

VFLAGS = -Wall -cc --trace --build -j 0 \
         -CFLAGS "-std=c++17 -O2" \
         --top-module $(TOP)

SRCS = $(RTL_DIR)/soc_top.v \
       $(RTL_DIR)/core_wrapper.v \
       $(RTL_DIR)/accel/lif_accelerator.v \
       $(RTL_DIR)/accel/lif_core.v \
       $(PICORV32)

firmware.elf: firmware.S link.ld
	riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Tlink.ld -o $@ firmware.S

firmware.hex: firmware.elf
	riscv32-unknown-elf-objcopy -O verilog firmware.elf firmware.hex

sim: firmware.hex
	verilator --trace --build -j 0 -Wno-fatal --top-module sim_top \
	    sim_top.v ../../third_party/picorv32/picorv32.v --exe tb_main.cpp
	./obj_dir/Vsim_top

waves:
	gtkwave waveform.vcd &

clean:
	rm -rf obj_dir *.vcd