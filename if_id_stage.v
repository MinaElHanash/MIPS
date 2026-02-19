module if_id_stage (
    input clk, rst,
    input write_enable, flush,
    input [31:0] instruction_in, pc_in, pc_plus_4_in,
    output reg [31:0] instruction_out, pc_out, pc_plus_4_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_out <= 32'd0;
            pc_plus_4_out <= 32'd0;
            pc_out <= 32'd0;
        end 
        else if (flush) begin
            instruction_out <= 32'd0;
            pc_plus_4_out <= 32'd0;
            pc_out <= 32'd0;
        end
        else if (write_enable) begin
            instruction_out <= instruction_in;
            pc_plus_4_out <= pc_plus_4_in;
            pc_out <= pc_in;
        end
        else begin
            instruction_out <= instruction_out;
            pc_plus_4_out <= pc_plus_4_out;
            pc_out <= pc_out;
        end
    end

endmodule