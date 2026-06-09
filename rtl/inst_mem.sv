module inst_mem(
    input  wire [31:0] addr,
    output wire [31:0] instr
);

    /* verilator lint_off UNUSEDSIGNAL */
    logic [21:0] s_ = {addr[31:12], addr[1:0]};
    /* verilator lint_on UNUSEDSIGNAL */

    reg [31:0] mem [0:1023];

    initial begin
        $readmemh("program.hex", mem);
    end

    assign instr = mem[addr[11:2]];
endmodule
