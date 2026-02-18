module if_id_stage (
    input clk, rst,
    input [31:0] instruction_in, pc_plus_4_in,
    output reg [31:0] instruction_out, pc_plus_4_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_out <= 32'd0;
            pc_plus_4_out <= 32'd0;
        end 
        else begin
            instruction_out <= instruction_in;
            pc_plus_4_out <= pc_plus_4_in;
        end
    end

endmodule