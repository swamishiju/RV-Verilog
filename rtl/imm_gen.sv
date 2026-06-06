`default_nettype none
import riscv_pkg::imm_type_t;

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
    
            riscv_pkg::IMM_I:
                imm = {{20{instr[31]}}, instr[31:20]};
    
            riscv_pkg::IMM_S:
                imm = {{20{instr[31]}},
                       instr[31:25],
                       instr[11:7]};
    
            riscv_pkg::IMM_B:
                imm = {{19{instr[31]}},
                       instr[31],
                       instr[7],
                       instr[30:25],
                       instr[11:8],
                       1'b0};
    
            riscv_pkg::IMM_U:
                imm = {instr[31:12], 12'b0};
    
            riscv_pkg::IMM_J:
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
