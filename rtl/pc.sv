module pc(
    input logic clk,
    input logic [31:0] pc_next,
    output logic [31:0] pc_
    );

    always_ff @(posedge clk) begin 
        pc_ <= pc_next;
    end

endmodule
