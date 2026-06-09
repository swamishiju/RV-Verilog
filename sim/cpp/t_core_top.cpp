#include <Vcore_top.h>

#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <random>

#define MAX_SIM_TIME 400
#define CHECK_EQ(dut, test, field, expected, actual)                                               \
    do {                                                                                           \
        if ((expected) != (actual)) {                                                              \
            fail(dut, test, dut->rs1, dut->rs2, dut->rd, expected, actual);                        \
        }                                                                                          \
    } while (0)

vluint64_t sim_time = 0;

void tick(Vcore_top* dut);
int main(int argc, char** argv) {
    auto dut = new Vcore_top;
    dut->instr = 0x06438313;
    tick(dut);
    std::cout << (int)dut->alu_op << " " << (int)dut->imm_gen_o << " " << (int)dut->alu_out << "\n";

    dut->instr = 0x06430313;
    tick(dut);
    std::cout << (int)dut->alu_op << " " << (int)dut->imm_gen_o << " " << (int)dut->alu_out << "\n";

    delete dut;

    return EXIT_SUCCESS;
}

void tick(Vcore_top* dut) {
    dut->clk = 0;
    dut->eval();
    sim_time++;

    dut->clk = 1;
    dut->eval();
    sim_time++;
}
