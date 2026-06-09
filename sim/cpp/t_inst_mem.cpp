#include <Vinst_mem.h>

#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <random>

int main(int argc, char** argv) {
    auto dut = new Vinst_mem;

    dut->addr = 0;
    dut->eval();

    std::cout << (int)dut->instr << "\nPASS\n";

    delete dut;

    return EXIT_SUCCESS;
}
