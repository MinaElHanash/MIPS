module mem_wb_stage (

    //*******************************************
    //inputs
    //*******************************************

    input clk, rst,

    // data signals
    input [31:0] memory_data_in, alu_result_in,
    input [4:0] register_destination_in,

    // control signals
    input jump_in, branch_in, pc_control_in, memory_to_register_in, reg_write_in,

    //*******************************************
    //outputs
    //*******************************************

    // data signals
    output reg [31:0] memory_data_out, alu_result_out,
    output reg [4:0] register_destination_out,

    // control signals
    output reg jump_out, branch_out, pc_control_out, memory_to_register_out, reg_write_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
                memory_data_out <= 32'd0;
                alu_result_out <= 32'd0;

                register_destination_out <= 5'd0;

                jump_out <= 1'd0;
                branch_out <= 1'd0;
                pc_control_out <= 1'd0;
                memory_to_register_out <= 1'd0;
                reg_write_out <= 1'd0;
        end
        else begin
                memory_data_out <= memory_data_in;
                alu_result_out <= alu_result_in;

                register_destination_out <= register_destination_in;

                jump_out <= jump_in;
                branch_out <= branch_in;
                pc_control_out <= pc_control_in;
                memory_to_register_out <= memory_to_register_in;
                reg_write_out <= reg_write_in;
        end
    end
    
endmodule