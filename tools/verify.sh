#!/usr/bin/env bash
set -euo pipefail

echo "== Verilator =="
verilator --version
echo "module smoke_test(); endmodule" > /tmp/smoke.v
verilator --lint-only /tmp/smoke.v && echo "[ok] verilator can lint/elaborate"
rm -f /tmp/smoke.v

echo "== riscv-gnu-toolchain =="
riscv32-unknown-elf-gcc --version
cat > /tmp/smoke.c <<'EOF'
int main(void) { return 0; }
EOF
riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -o /tmp/smoke.elf /tmp/smoke.c
riscv32-unknown-elf-objdump -d /tmp/smoke.elf | grep -q "main" && echo "[ok] compiles and links"
rm -f /tmp/smoke.c /tmp/smoke.elf

echo "== gtkwave =="
gtkwave --version

echo "All tools verified."