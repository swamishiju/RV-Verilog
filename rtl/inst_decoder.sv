`default_nettype none
import riscv_pkg::alu_op_t;
import riscv_pkg::imm_type_t;
    
typedef enum logic [6:0] {
    OPCODE_LOAD      = 7'b000_0011,
    OPCODE_MISC_MEM  = 7'b000_1111, // FENCE

    OPCODE_OP_IMM    = 7'b001_0011,
    OPCODE_AUIPC     = 7'b001_0111,

    OPCODE_STORE     = 7'b010_0011,

    OPCODE_OP        = 7'b011_0011,
    OPCODE_LUI       = 7'b011_0111,

    OPCODE_BRANCH    = 7'b110_0011,
    OPCODE_JALR      = 7'b110_0111,
    OPCODE_JAL       = 7'b110_1111,

    OPCODE_SYSTEM    = 7'b111_0011
} opcode_t;


module inst_decoder(

    // input  logic        clk,

    input   logic [31:0] instr,
    output  logic [31:0] instr_o,
    
    output  logic        we_o,
    output  alu_op_t     alu_op,
    output  logic [4:0]  rs1_o,
    output  logic [4:0]  rs2_o,
    output  logic [4:0]  rd_o,
    output  imm_type_t   imm_type_o
    );

    opcode_t opcode;
    logic [4:0]  rs1, rs2, rd;
    logic [2:0]  funct3;
    logic [6:0]  funct7;

    assign opcode = opcode_t'(instr[6:0]);
    assign rd = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign funct7 = instr[31:25];

    assign instr_o = instr;

    always_comb begin 
        unique case(opcode)
        OPCODE_LUI: 
            {rs1_o, rs2_o, rd_o, we_o, imm_type_o, alu_op} = {4'b0, 4'b0, rd, 1'b1, riscv_pkg::IMM_U, riscv_pkg::ALU_NONE};
        OPCODE_AUIPC: 
            // TODO: Fix with PC
            {rs1_o, rs2_o, rd_o, we_o, imm_type_o, alu_op} = {4'b0, 4'b0, rd, 1'b1, riscv_pkg::IMM_U, riscv_pkg::ALU_NONE};
        OPCODE_OP_IMM:
            {rs1_o, rs2_o, rd_o, we_o, imm_type_o, alu_op} = {rs1, 4'b0, rd, 1'b0, riscv_pkg::IMM_I, alu_op_t'(funct3)};
        OPCODE_OP: begin
            {rs1_o, rs2_o, rd_o, we_o, imm_type_o} = {rs1, rs2, rd, 1'b0, riscv_pkg::IMM_NONE};
            if (funct3 != 3'h0) alu_op = alu_op_t'(funct3);
            else alu_op = (funct7 == 7'h20)? riscv_pkg::ALU_SUB : riscv_pkg::ALU_ADD;
        end
        default: begin
        end
        endcase
    end
endmodule
