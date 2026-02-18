module ex_mem_stage (

    //*******************************************
    //inputs
    //*******************************************

    input clk, rst,
    input [31:0] branch_target_in, alu_result_in, reg_file_out_2_in,
    input [4:0] register_destination_in,
    input zero_flag_in,

    // control signals
    input jump_in, branch_in, memory_read_in, memory_write_in, memory_to_register_in,
    input reg_write_in, pc_control_in, memory_write_source_in, memory_read_source_in,

    //*******************************************
    // outputs
    //*******************************************

    output reg [31:0] branch_target_out, alu_result_out, reg_file_out_2_out,
    output reg [4:0] register_destination_out,
    output reg zero_flag_out,

    // control signals
    output reg jump_out, branch_out, memory_read_out, memory_write_out, memory_to_register_out,
    output reg reg_write_out, pc_control_out, memory_write_source_out, memory_read_source_out
    
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
                branch_target_out <= 32'd0;
                alu_result_out <= 32'd0;
                reg_file_out_2_out <= 32'd0;

                register_destination_out <= 5'd0;

                zero_flag_out <= 1'd0;

                jump_out <= 1'd0;
                branch_out <= 1'd0;
                memory_read_out <= 1'd0;
                memory_write_out <= 1'd0;
                memory_to_register_out <= 1'd0;
                reg_write_out <= 1'd0;
                pc_control_out <= 1'd0;
                memory_write_source_out <= 1'd0;
                memory_read_source_out <= 1'd0;
        end
        else begin
                branch_target_out <= branch_target_in;
                alu_result_out <= alu_result_in;
                reg_file_out_2_out <= reg_file_out_2_in;

                register_destination_out <= register_destination_in;

                zero_flag_out <= zero_flag_in;

                jump_out <= jump_in;
                branch_out <= branch_in;
                memory_read_out <= memory_read_in;
                memory_write_out <= memory_write_in;
                memory_to_register_out <= memory_to_register_in;
                reg_write_out <= reg_write_in;
                pc_control_out <= pc_control_in;
                memory_write_source_out <= memory_write_source_in;
                memory_read_source_out <= memory_read_source_in;
        end
    end
endmodule