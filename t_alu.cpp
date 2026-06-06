#include "obj_dir/Valu.h"
#include <stdlib.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define MAX_SIM_TIME 400
vluint64_t sim_time = 0;

int main(int argc, char **argv, char **env) {
  Valu *dut = new Valu;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("waveform.vcd");

  while (sim_time < MAX_SIM_TIME) {
    // dut->clk ^= 1;
    dut->eval();

    if (sim_time == 50) {
      dut->a = 10;
      dut->b = -30;
      dut->ALU_Select = 0;
    }
    if (sim_time == 100) {
      dut->a = 2 << 30;
      dut->b = 2 << 30;
      dut->ALU_Select = 0;
    }
    if (sim_time == 150) {
      dut->a = -10;
      dut->ALU_Select = 0;
    }

    if (sim_time == 200) {
      dut->ALU_Select = 1;
    }

    m_trace->dump(sim_time);
    sim_time++;
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
}
