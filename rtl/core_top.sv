`default_nettype none

module core_top(
    input  logic clk,
    output logic [31:0] instr,
    output logic [31:0] alu_out,
    output logic [31:0] pc_
    );

    import riscv_pkg::*;
    logic [31:0] pc_next; //, pc_;
    logic [31:0] imm_gen_o;
    // logic [31:0] instr;

    logic        we;
    logic [31:0] wd, rd1, rd2;

    /* verilator lint_off UNUSEDSIGNAL */
    logic mem_write, mem_read;
    /* verilator lint_on UNUSEDSIGNAL */

    logic branch, branch_inv, jump;
    pc_src_t     pc_src;
    res_src_t    res_src;
    imm_type_t   imm_type_o;

    alu_op_t     alu_op;
    alu_srca_t   alu_srca;
    alu_srcb_t   alu_srcb;
    logic alu_z;
    // logic [31:0] alu_out;
    
    /* verilator lint_off UNUSEDSIGNAL */
    logic N, V, C;
    /* verilator lint_on UNUSEDSIGNAL */

    pc program_counter(
        .clk(clk), 
        .pc_next(pc_next), 
        .pc_(pc_)
    );

    initial pc_ = 0;

    pc_handler counter_handler(
        .jump(jump), .branch(branch), .branch_inv(branch_inv), .alu_z(alu_z),
        .pc_src(pc_src), .pc(pc_), .rd1(rd1), .offset(imm_gen_o), .pc_next(pc_next)
    );

    inst_mem instruction_memory(
        .addr(pc_),
        .instr(instr)
    );


    reg_file register_file (
        .clk(clk), .rst(1'b0),
        .we(we), .rs1(instr[19:15]), .rs2(instr[24:20]), .rd(instr[11:7]), .wd(wd),
        .rd1(rd1), .rd2(rd2)
    );

    inst_decoder instruction_decoder (
        .instr(instr),
        .reg_write(we), .mem_write(mem_write), .mem_read(mem_read),
            .branch(branch), .branch_inv(branch_inv), .jump(jump),
            .pc_src(pc_src), .res_src(res_src), .alu_op(alu_op), 
            .alu_srca(alu_srca), .alu_srcb(alu_srcb), .imm_type_o(imm_type_o)
    );

    imm_gen immediate_generator (
        .instr(instr), .imm_sel(imm_type_o),
        .imm(imm_gen_o)
    );

    alu AL_Unit(
        .a(
            (alu_srca == ALU_S_REGA)? rd1:
            (alu_srca == ALU_S_PC)? pc_: pc_ + 4
        ),
        .b(
            (alu_srcb == ALU_S_REGB)? rd2: imm_gen_o
        ),
        .ALU_Select(alu_op),
        .out(alu_out),
        .Z(alu_z), .N(N), .V(V), .C(C)
    );

    // Fix memory
    assign wd = (res_src == RES_S_ALU)? alu_out: 32'b0;


endmodule
