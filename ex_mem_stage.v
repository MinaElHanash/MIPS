module ex_mem_stage (

    //*******************************************
    //inputs
    //*******************************************

    input clk, rst, flush,
    input [31:0] branch_target_in, pc_in, pc_plus_4_in, alu_result_in, reg_file_out_2_in,
    input [4:0] register_destination_in, register_file_output_2_in,
    input zero_flag_in, overflow_flag_in,

    // control signals
    input branch_in, memory_read_in, memory_write_in, memory_to_register_in,
    input reg_write_in, pc_control_in, memory_write_source_in, memory_read_source_in,

    //*******************************************
    // outputs
    //*******************************************

    output reg [31:0] branch_target_out, pc_out, pc_plus_4_out, alu_result_out, reg_file_out_2_out,
    output reg [4:0] register_destination_out, register_file_output_2_out,
    output reg zero_flag_out, overflow_flag_out,

    // control signals
    output reg branch_out, memory_read_out, memory_write_out, memory_to_register_out,
    output reg reg_write_out, pc_control_out, memory_write_source_out, memory_read_source_out
    
);

    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
                branch_target_out <= 32'd0;
                alu_result_out <= 32'd0;
                reg_file_out_2_out <= 32'd0;
                pc_plus_4_out <= 32'd0;
                pc_out <= 32'd0;

                register_destination_out <= 5'd0;
                register_file_output_2_out <= 5'd0;

                zero_flag_out <= 1'd0;
                overflow_flag_out <= 1'd0;

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
                pc_plus_4_out <= pc_plus_4_in;
                pc_out <= pc_in;

                register_destination_out <= register_destination_in;
                register_file_output_2_out <= register_file_output_2_in;

                zero_flag_out <= zero_flag_in;
                overflow_flag_out <= overflow_flag_in;

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