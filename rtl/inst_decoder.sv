`default_nettype none
import riscv_pkg::alu_op_t;
import riscv_pkg::imm_type_t;
import riscv_pkg::pc_src_t;
import riscv_pkg::alu_srca_t;
import riscv_pkg::alu_srcb_t;
import riscv_pkg::res_src_t;
import riscv_pkg::yes;
import riscv_pkg::no;

typedef enum logic [6:0] {
    OPCODE_LUI       = 7'b011_0111,

    OPCODE_AUIPC     = 7'b001_0111,

    OPCODE_JAL       = 7'b110_1111,
    OPCODE_JALR      = 7'b110_0111,
    OPCODE_BRANCH    = 7'b110_0011,

    OPCODE_LOAD      = 7'b000_0011,
    OPCODE_MISC_MEM  = 7'b000_1111, // FENCE

    OPCODE_OP_IMM    = 7'b001_0011,

    OPCODE_STORE     = 7'b010_0011,

    OPCODE_OP        = 7'b011_0011,

    OPCODE_SYSTEM    = 7'b111_0011
} opcode_t;


module inst_decoder(

    // input  logic        clk,

    input   logic [31:0] instr,
    
    output  logic        reg_write,
    output  logic        mem_write,
    output  logic        mem_read,

    output  logic        branch,
    output  logic        branch_inv,
    output  logic        jump,

    output  pc_src_t     pc_src,
    output  res_src_t    res_src,
    output  alu_op_t     alu_op,
    output  alu_srca_t   alu_srca,
    output  alu_srcb_t   alu_srcb,
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

    always_comb begin 
        unique case(opcode)
        OPCODE_LUI:  begin
            reg_write   = yes;
            mem_write   = no;
            mem_read    = no;

            branch      = no;
            branch_inv  = no;
            jump        = no;
            imm_type_o  = IMM_U;

            pc_src      = riscv_pkg::PC_S_PC;
            res_src     = riscv_pkg::RES_S_ALU;

            alu_op      = riscv_pkg::ALU_B;
            alu_srca    = riscv_pkg::ALU_S_REGA;
            alu_srcb    = riscv_pkg::ALU_S_IMM;
        end
        OPCODE_AUIPC: begin
            reg_write   = yes;
            mem_write   = no;
            mem_read    = no;

            branch      = no;
            branch_inv  = no;
            jump        = no;
            lui         = no;
            imm_type_o  = IMM_U;

            pc_src      = riscv_pkg::PC_S_PC;
            res_src     = riscv_pkg::RES_S_ALU;

            alu_op      = riscv_pkg::ALU_ADD;
            alu_srca    = riscv_pkg::ALU_S_PC;
            alu_srcb    = riscv_pkg::ALU_S_IMM;
        end
        OPCODE_JAL: begin
            reg_write   = yes;
            mem_write   = no;
            mem_read    = no;

            // jump signal is active, pc_new = pc+offset
            branch      = no;
            jump        = yes;
            imm_type_o  = IMM_J;

            pc_src      = riscv_pkg::PC_S_REG;
            res_src     = riscv_pkg::RES_S_ALU;

            // Save pc+4 in rd
            alu_op      = riscv_pkg::ALU_A;
            alu_srca    = riscv_pkg::ALU_S_PC4;
            alu_srcb    = riscv_pkg::ALU_S_REGB;
        end
        OPCODE_JALR: begin
            reg_write   = yes;
            mem_write   = no;
            mem_read    = no;

            // jump signal is active and pc source is reg, pc_new = rs1+offset
            branch      = no;
            branch_inv  = no;
            jump        = yes;
            imm_type_o  = IMM_I;

            pc_src      = riscv_pkg::PC_S_REG;
            res_src     = riscv_pkg::RES_S_ALU;

            // Save pc+4 in rd
            alu_op      = riscv_pkg::ALU_A;
            alu_srca    = riscv_pkg::ALU_S_PC4;
            alu_srcb    = riscv_pkg::ALU_S_REGB;
        end
        OPCODE_BRANCH: begin 
            reg_write   = no;
            mem_write   = no;
            mem_read    = no;

            // jump signal is active and pc source is reg, pc_new = rs1+offset
            branch      = yes;
            jump        = yes;
            imm_type_o  = IMM_B;

            unique case(funct3) 
            000: {branch_inv, alu_op} = {no, riscv_pkg::ALU_XOR};   // BEQ
            001: {branch_inv, alu_op} = {yes, riscv_pkg::ALU_XOR};  // BNE
            100: {branch_inv, alu_op} = {no, riscv_pkg::ALU_SLT};   // BLT
            101: {branch_inv, alu_op} = {yes, riscv_pkg::ALU_SLT};  // BGE
            110: {branch_inv, alu_op} = {no, riscv_pkg::ALU_SLTU};  // BLTU
            101: {branch_inv, alu_op} = {yes, riscv_pkg::ALU_SLTU}; // BGEU
            default: begin end
            endcase

            pc_src      = riscv_pkg::PC_S_PC;
            res_src     = riscv_pkg::RES_S_ALU;

            // Save pc+4 in rd
            alu_srca    = riscv_pkg::ALU_S_REGA;
            alu_srcb    = riscv_pkg::ALU_S_REGB;
        end
        OPCODE_OP_IMM: begin
            reg_write  = 1'b1;
            mem_write  = 1'b0;
            pc_src     = riscv_pkg::PC_S_INC;
            lui        = riscv_pkg::LUI_NO;
            res_src    = riscv_pkg::RES_S_ALU;
            alu_src    = riscv_pkg::ALU_S_I;
            alu_op     = alu_op_t'(funct3);
            imm_type_o = IMM_I;
        end
        OPCODE_OP: begin
            reg_write  = 1'b1;
            mem_write  = 1'b0;
            pc_src     = riscv_pkg::PC_S_INC;
            lui        = riscv_pkg::LUI_NO;
            res_src    = riscv_pkg::RES_S_ALU;
            alu_src    = riscv_pkg::ALU_S_R;

            if (funct3 != 3'h0) alu_op = alu_op_t'(funct3);
            else alu_op = (funct7 == 7'h20)? riscv_pkg::ALU_SUB : riscv_pkg::ALU_ADD;
            
            imm_type_o = IMM_NONE;
        end
        default: begin end
        endcase
    end
endmodule
