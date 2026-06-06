`default_nettype none
import riscv_pkg::alu_op_t;
    
typedef enum logic [6:0] {
    OPCODE_LOAD      = 7'b0000011,
    OPCODE_MISC_MEM  = 7'b0001111, // FENCE

    OPCODE_OP_IMM    = 7'b0010011,
    OPCODE_AUIPC     = 7'b0010111,

    OPCODE_STORE     = 7'b0100011,

    OPCODE_OP        = 7'b0110011,
    OPCODE_LUI       = 7'b0110111,

    OPCODE_BRANCH    = 7'b1100011,
    OPCODE_JALR      = 7'b1100111,
    OPCODE_JAL       = 7'b1101111,

    OPCODE_SYSTEM    = 7'b1110011
} opcode_t;


module inst_decoder(

    // input  logic        clk,

    input   logic [31:0] instr,
    output  logic [31:0] instr_o,
    
    output  logic        we,
    output  alu_op_t     alu_op,
    output  logic [4:0]  rs1,
    output  logic [4:0]  rs2,
    output  logic [4:0]  rd
    );


    opcode_t opcode;
    assign opcode = opcode_t'(instr[6:0]);
    assign instr_o = instr;

    always_comb begin 
        unique case(opcode)
        OPCODE_OP: begin
            
        end
        default: begin
        end
        endcase
    end
endmodule
