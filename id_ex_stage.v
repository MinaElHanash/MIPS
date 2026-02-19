module id_ex_stage (

    //*******************************************
    //inputs
    //*******************************************

    // system signals
    input clk, rst,
    input flush,

    // data signals
    input [31:0] pc_in, pc_plus_4_in, reg_file_out_1_in, reg_file_out_2_in, sign_extended_in,
    input [4:0] reg_rs_address_in, reg_rt_address_in, reg_rd_address_in,
    input [5:0] funct_in,

    // control signals
    input [1:0] register_destination_in, alu_op_in,
    input branch_in, memory_read_in, memory_write_in, memory_to_register_in,
    input alu_source_in, reg_write_in, pc_control_in, memory_write_source_in, memory_read_source_in,

    //*******************************************
    // outputs
    //*******************************************

    // data signals
    output reg [31:0] pc_out, pc_plus_4_out, reg_file_out_1_out, reg_file_out_2_out, sign_extended_out,
    output reg [4:0] reg_rs_address_out, reg_rt_address_out, reg_rd_address_out,
    output reg [5:0] funct_out,

    // control signals
    output reg [1:0] register_destination_out, alu_op_out,
    output reg branch_out, memory_read_out, memory_write_out, memory_to_register_out,
    output reg alu_source_out, reg_write_out, pc_control_out, memory_write_source_out, memory_read_source_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
                pc_out <= 32'd0;
                pc_plus_4_out <= 32'd0;
                reg_file_out_1_out <= 32'd0;
                reg_file_out_2_out <= 32'd0;
                sign_extended_out <= 32'd0;

                reg_rs_address_out <= 5'd0;
                reg_rt_address_out <= 5'd0;
                reg_rd_address_out <= 5'd0;

                funct_out <= 6'd0;

                register_destination_out <= 2'd0;
                alu_op_out <= 2'd0;

                branch_out <= 1'd0;
                memory_read_out <= 1'd0;
                memory_write_out <= 1'd0;
                memory_to_register_out <= 1'd0;
                alu_source_out <= 1'd0;
                reg_write_out <= 1'd0;
                pc_control_out <= 1'd0;
                memory_write_source_out <= 1'd0;
                memory_read_source_out <= 1'd0;
        end
        else if (flush) begin
                pc_out <= 32'd0;
                pc_plus_4_out <= 32'd0;
                reg_file_out_1_out <= 32'd0;
                reg_file_out_2_out <= 32'd0;
                sign_extended_out <= 32'd0;

                reg_rs_address_out <= 5'd0;
                reg_rt_address_out <= 5'd0;
                reg_rd_address_out <= 5'd0;

                funct_out <= 6'd0;
                
                register_destination_out <= 2'd0;
                alu_op_out <= 2'd0;

                branch_out <= 1'd0;
                memory_read_out <= 1'd0;
                memory_write_out <= 1'd0;
                memory_to_register_out <= 1'd0;
                alu_source_out <= 1'd0;
                reg_write_out <= 1'd0;
                pc_control_out <= 1'd0;
                memory_write_source_out <= 1'd0;
                memory_read_source_out <= 1'd0;
        end
        else begin
                pc_out <= pc_in;
                pc_plus_4_out <= pc_plus_4_in;
                reg_file_out_1_out <= reg_file_out_1_in;
                reg_file_out_2_out <= reg_file_out_2_in;
                sign_extended_out <= sign_extended_in;

                reg_rs_address_out <= reg_rs_address_in;
                reg_rt_address_out <= reg_rt_address_in;
                reg_rd_address_out <= reg_rd_address_in;

                funct_out <= funct_in;

                register_destination_out <= register_destination_in;
                alu_op_out <= alu_op_in;

                branch_out <= branch_in;
                memory_read_out <= memory_read_in;
                memory_write_out <= memory_write_in;
                memory_to_register_out <= memory_to_register_in;
                alu_source_out <= alu_source_in;
                reg_write_out <= reg_write_in;
                pc_control_out <= pc_control_in;
                memory_write_source_out <= memory_write_source_in;
                memory_read_source_out <= memory_read_source_in;
        end
        
    end
    
endmodule