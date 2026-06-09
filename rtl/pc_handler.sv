import riscv_pkg::pc_src_t;
import riscv_pkg::yes;
import riscv_pkg::no;

module pc_handler(
    input logic jump,
    input logic branch,
    input logic branch_inv,
    input logic alu_z,

    input pc_src_t pc_src,
    input logic [31:0] pc,
    input logic [31:0] rd1,
    input logic [31:0] offset,

    output logic [31:0] pc_next
    );
    logic [31:0] m1, m2;
    assign m1 = (pc_src == riscv_pkg::PC_S_PC)? pc: rd1;
    assign m2 = (((alu_z ^ branch_inv) & branch) | jump)? offset: 32'd4;
    assign pc_next = m1 + m2;
endmodule
