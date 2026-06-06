typedef enum logic [2:0] {
    IMM_I = 3'd0,
    IMM_S = 3'd1,
    IMM_B = 3'd2,
    IMM_U = 3'd3,
    IMM_J = 3'd4,
    IMM_NONE = 3'd5
} imm_type_t;

module imm_gen (
    input  logic [31:0] instr,
    input  imm_type_t  imm_sel,
    output logic [31:0] imm
);

    /* verilator lint_off UNUSEDSIGNAL */
    logic [6:0] opcode = instr[6:0];
    /* verilator lint_on UNUSEDSIGNAL */

    always_comb begin
        unique case (imm_sel)
    
            IMM_I:
                imm = {{20{instr[31]}}, instr[31:20]};
    
            IMM_S:
                imm = {{20{instr[31]}},
                       instr[31:25],
                       instr[11:7]};
    
            IMM_B:
                imm = {{19{instr[31]}},
                       instr[31],
                       instr[7],
                       instr[30:25],
                       instr[11:8],
                       1'b0};
    
            IMM_U:
                imm = {instr[31:12], 12'b0};
    
            IMM_J:
                imm = {{11{instr[31]}},
                       instr[31],
                       instr[19:12],
                       instr[20],
                       instr[30:21],
                       1'b0};
    
            default:
                imm = 32'd0;
        endcase
    end

endmodule
