`default_nettype none

module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [1:0] ALU_Select,
    output wire [31:0] out,
    output wire Z, N, V, C
);
    wire[31:0] out_and, out_or, sum;
    wire cout;

    assign out_and = a & b;
    assign out_or  = a | b;

    assign {cout, sum} = (ALU_Select[0] == 1)? a + ~{1'b1, b} + 1'b1 : a + b;    
    assign out = (ALU_Select[1] == 1'b0)? sum:
                 (ALU_Select[1:0] == 2'b10)? out_and: out_or;

    assign Z = &~out;
    assign N = out[31];
    assign C = cout & (~ALU_Select[1]);
    assign V = (~(a[31] ^ b[31] ^ ALU_Select[0])) & 
               (~ALU_Select[1]) &
               (a[31] ^ sum[31]);

endmodule
