`default_nettype none

module reg_file (
    input  logic        clk,
    input  logic        rst,

    input  logic        we,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] wd,

    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] regs [31:0];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    integer j;
    always_ff @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < 32; j = j + 1)
                regs[j] <= 32'b0;
        end
        else if (we && (rd != 5'd0)) begin
            regs[rd] <= wd;
        end

        rd1 <= (rst) ? 32'b0 : regs[rs1];
        rd2 <= (rst) ? 32'b0 : regs[rs2];
    end

endmodule
