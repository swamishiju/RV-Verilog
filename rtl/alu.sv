`default_nettype none
import riscv_pkg::alu_op_t;


module alu(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  alu_op_t  ALU_Select,
    output logic [31:0] out,
    output logic        Z, N, V, C
);

    logic [31:0] sum;
    logic        cout;

    assign {cout, sum} = (ALU_Select == riscv_pkg::ALU_SUB)? a + ~{1'b1, b} + 1'b1 : a + b;    

    always_comb begin
        unique case(ALU_Select) 
            riscv_pkg::ALU_ADD  : out = sum;
            riscv_pkg::ALU_SUB  : out = sum;
            riscv_pkg::ALU_AND  : out = a & b;
            riscv_pkg::ALU_OR   : out = a | b;
            riscv_pkg::ALU_XOR  : out = a ^ b;
            riscv_pkg::ALU_SLL  : out = a << b[4:0];   
            riscv_pkg::ALU_SRL  : out = a >> b[4:0];
            riscv_pkg::ALU_SRA  : out = $signed(a) >>> b[4:0];
            riscv_pkg::ALU_SLT  : out = ($signed(a) < $signed(b))? 1:0;
            riscv_pkg::ALU_SLTU : out = (a < b)? 1: 0;
            default: out = 32'b0;
        endcase
    end

    assign Z = &~out;
    assign N = out[31];
    assign C = cout &
               ((ALU_Select == riscv_pkg::ALU_ADD) |
               (ALU_Select == riscv_pkg::ALU_SUB));
    assign V = (~(a[31] ^ b[31] ^ (ALU_Select == riscv_pkg::ALU_SUB))) & 
               (ALU_Select == riscv_pkg::ALU_ADD | ALU_Select == riscv_pkg::ALU_SUB) &
               (a[31] ^ sum[31]);

endmodule
