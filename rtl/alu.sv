`default_nettype none

typedef enum logic [3:0] {
    ALU_ADD  = 4'd0,
    ALU_SUB  = 4'd1,
    ALU_AND  = 4'd2,
    ALU_OR   = 4'd3,
    ALU_XOR  = 4'd4,
    ALU_SLL  = 4'd5,
    ALU_SRL  = 4'd6,
    ALU_SRA  = 4'd7,
    ALU_SLT  = 4'd8,
    ALU_SLTU = 4'd9
} alu_op_t;

module alu(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  alu_op_t  ALU_Select,
    output logic [31:0] out,
    output logic        Z, N, V, C
);
    logic [31:0] sum;
    logic        cout;

    assign {cout, sum} = (ALU_Select[0] == 1)? a + ~{1'b1, b} + 1'b1 : a + b;    

    always_comb begin
        unique case(ALU_Select) 
            ALU_ADD  : out = sum;
            ALU_SUB  : out = sum;
            ALU_AND  : out = a & b;
            ALU_OR   : out = a | b;
            ALU_XOR  : out = a ^ b;
            ALU_SLL  : out = a << b[4:0];   
            ALU_SRL  : out = a >> b[4:0];
            ALU_SRA  : out = $signed(a) >>> b[4:0];
            ALU_SLT  : out = ($signed(a) < $signed(b))? 1:0;
            ALU_SLTU : out = (a < b)? 1: 0;
            default: out = 32'b0;
        endcase
    end

    assign Z = &~out;
    assign N = out[31];
    assign C = cout & (ALU_Select == ALU_ADD | ALU_Select == ALU_SUB);
    assign V = (~(a[31] ^ b[31] ^ ALU_Select[0])) & 
               (ALU_Select == ALU_ADD | ALU_Select == ALU_SUB) &
               (a[31] ^ sum[31]);

endmodule
