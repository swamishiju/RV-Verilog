package riscv_pkg;


typedef enum logic {
    no  = 1'd0,
    yes = 1'd1
} active;

typedef enum logic [3:0] {
    ALU_ADD  = 4'd0,
    ALU_SLL  = 4'd1,
    ALU_SLT  = 4'd2,
    ALU_SLTU = 4'd3,
    ALU_XOR  = 4'd4,
    ALU_SRA  = 4'd5,
    ALU_OR   = 4'd6,
    ALU_AND  = 4'd7,
    ALU_SUB  = 4'd8,
    ALU_SRL  = 4'd9,
    ALU_A    = 4'd10,
    ALU_B    = 4'd11,
    ALU_NONE = 4'd12
} alu_op_t;

typedef enum logic [2:0] {
    IMM_I = 3'd0,
    IMM_S = 3'd1,
    IMM_B = 3'd2,
    IMM_U = 3'd3,
    IMM_J = 3'd4,
    IMM_NONE = 3'd5
} imm_type_t;

typedef enum logic {
    PC_S_REG,
    PC_S_PC
} pc_src_t;

typedef enum logic {
    ALU_S_REGB,
    ALU_S_IMM
} alu_srcb_t;

typedef enum logic[1:0] {
    ALU_S_REGA,
    ALU_S_PC4,
    ALU_S_PC
} alu_srca_t;

typedef enum logic {
    RES_S_ALU,
    RES_S_MEM
} res_src_t;
endpackage
