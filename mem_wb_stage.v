module mem_wb_stage (

    //*******************************************
    //inputs
    //*******************************************

    input clk, rst,

    input [31:0] pc_in,

    // data signals
    input [31:0] memory_data_in, alu_result_in,
    input [4:0] register_destination_in,

    // control signals
    input memory_to_register_in, reg_write_in,
    input overflow_flag_in,

    //*******************************************
    //outputs
    //*******************************************

    output reg [31:0] pc_out,

    // data signals
    output reg [31:0] memory_data_out, alu_result_out,
    output reg [4:0] register_destination_out,

    // control signals
    output reg memory_to_register_out, reg_write_out,
    output reg overflow_flag_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
                pc_out <= 32'd0;
                
                memory_data_out <= 32'd0;
                alu_result_out <= 32'd0;

                register_destination_out <= 5'd0;

                memory_to_register_out <= 1'd0;
                reg_write_out <= 1'd0;

                overflow_flag_out <= 1'd0;
        end
        else begin
                pc_out <= pc_in;
                
                memory_data_out <= memory_data_in;
                alu_result_out <= alu_result_in;

                register_destination_out <= register_destination_in;

                memory_to_register_out <= memory_to_register_in;
                reg_write_out <= reg_write_in;

                overflow_flag_out <= overflow_flag_in;
        end
    end
    
endmodule