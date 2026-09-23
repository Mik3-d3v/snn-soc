#include "Vsim_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    auto* top = new Vsim_top;
    Verilated::traceEverOn(true);
    auto* tfp = new VerilatedVcdC;
    top->trace(tfp, 5);
    tfp->open("waveform.vcd");

    vluint64_t t = 0;
    top->resetn = 0; top->clk = 0;

    for (int cycle = 0; cycle < 200000; cycle++) {
        for (int phase = 0; phase < 2; phase++) {
            top->clk = !top->clk;
            if (cycle == 5) top->resetn = 1;
            top->eval();
            tfp->dump(t++);
        }
        if (Verilated::gotFinish()) break;
    }
    tfp->close();
    top->final();
    delete top;
    return 0;
}