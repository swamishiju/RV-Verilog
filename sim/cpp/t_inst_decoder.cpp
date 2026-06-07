// #include <Vreg_file.h>
//
// #include <iostream>
#include <stdlib.h>
// #include <verilated.h>
// #include <verilated_fst_c.h>
//
// #define MAX_SIM_TIME 400
// #define CHECK_EQ(dut, test, field, expected, actual) \
//     do { \
//         if ((expected) != (actual)) { \
//             fail(dut, test, dut->rs1, dut->rs2, dut->rd, expected, actual); \
//         } \
//     } while (0)
//
// vluint64_t sim_time = 0;
// VerilatedFstC* m_trace = new VerilatedFstC;
//
// void fail(const Vreg_file* dut, const char* test, uint8_t rs1, uint8_t rs2, uint8_t rd,
//           uint32_t expected, uint32_t actual);
//
// void tick(Vreg_file* dut);
// void write_reg(Vreg_file* dut, uint8_t rd, uint32_t value);
// uint32_t read_rs1(Vreg_file* dut, uint8_t rs1);
// uint32_t read_rs2(Vreg_file* dut, uint8_t rs2);

int main(int argc, char** argv, char** env) {
    // Vreg_file* dut = new Vreg_file;

    // Verilated::traceEverOn(true);
    // dut->trace(m_trace, 5);
    // m_trace->open("waveform.fst");

    // write_reg(dut, 0, 0xDEADBEEF);
    // CHECK_EQ(dut, "x0 hardwired", "rd1", 0, read_rs1(dut, 0));
    // CHECK_EQ(dut, "x0 hardwired", "rd2", 0, read_rs2(dut, 0));

    // write_reg(dut, 1, 0x12345678);
    // CHECK_EQ(dut, "x1 write", "rd1", 0x12345678, read_rs1(dut, 1));

    // write_reg(dut, 5, 0xAAAAAAAA);
    // write_reg(dut, 6, 0x55555555);
    // CHECK_EQ(dut, "x5,x6 2 port simul read", "rd1", 0xAAAAAAAA, read_rs1(dut, 5));
    // CHECK_EQ(dut, "x5,x6 2 port simul read", "rd2", 0x55555555, read_rs2(dut, 6));

    // dut->we = 0;
    // dut->rd = 7;
    // dut->wd = 0xDEADCAFE;
    // tick(dut);
    // CHECK_EQ(dut, "Try write without enable", "rd1", 0, read_rs1(dut, 7));

    // for (int i = 1; i < 32; ++i) {
    //     write_reg(dut, i, i * 0x11111111);
    // }

    // for (int i = 1; i < 32; ++i) {
    //     CHECK_EQ(dut, "All reg write", "rd1", uint32_t(i * 0x11111111), read_rs1(dut, i));
    // }

    // m_trace->close();
    // delete dut;
    exit(EXIT_SUCCESS);
}

// void tick(Vreg_file* dut) {
//     dut->clk = 0;
//     dut->eval();
//     sim_time++;
//     m_trace->dump(sim_time);
//
//     dut->clk = 1;
//     dut->eval();
//     sim_time++;
//     m_trace->dump(sim_time);
// }
//
// void write_reg(Vreg_file* dut, uint8_t rd, uint32_t value) {
//     dut->we = 1;
//     dut->rd = rd;
//     dut->wd = value;
//
//     tick(dut);
//
//     dut->we = 0;
// }
//
// uint32_t read_rs1(Vreg_file* dut, uint8_t rs1) {
//     dut->rs1 = rs1;
//     dut->eval();
//
//     return dut->rd1;
// }
//
// uint32_t read_rs2(Vreg_file* dut, uint8_t rs2) {
//     dut->rs2 = rs2;
//     dut->eval();
//
//     return dut->rd2;
// }
//
// void fail(const Vreg_file* dut, const char* test, uint8_t rs1, uint8_t rs2, uint8_t rd,
//           uint32_t expected, uint32_t actual) {
//     std::cerr << "FAIL\n"
//               << "test     : " << test << '\n'
//               << "sim_time : " << sim_time << '\n'
//               << "rs1      : " << unsigned(rs1) << '\n'
//               << "rs2      : " << unsigned(rs2) << '\n'
//               << "rd       : " << unsigned(rd) << '\n'
//               << "expected : 0x" << std::hex << expected << '\n'
//               << "actual   : 0x" << actual << '\n';
//
//     m_trace->close();
//     delete dut;
//     std::exit(EXIT_FAILURE);
// }
