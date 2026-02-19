module forwarding_unit (
    input [4:0] destination_register_of_1st_previous_instruction,
    input [4:0] destination_register_of_2nd_previous_instruction,
    input [4:0] source_register_1, source_register_2,
    input reg_write_1st_instruction, reg_write_2nd_instruction,

    output reg [1:0] alu_input_1, alu_input_2
);

    always @(*) begin
        if (source_register_1 == 5'd0) begin
            alu_input_1 = 2'b00; // if source is $0 register then pass 32'd0
        end
        else if ((source_register_1 == destination_register_of_1st_previous_instruction) && reg_write_1st_instruction) begin
            alu_input_1 = 2'b01; // pass the value from ex_mem registe
        end
        else if ((source_register_1 == destination_register_of_2nd_previous_instruction) && reg_write_2nd_instruction) begin
            alu_input_1 = 2'b10; // pass the value from mem_wb registe
        end
        else alu_input_1 = 2'b00; // pass the degault value form the single cycle (read data 1)
    end

    always @(*) begin
        if (source_register_2 == 5'd0) begin
            alu_input_2 = 2'b00; // if source is $0 register then pass 32'd0
        end
        else if ((source_register_2 == destination_register_of_1st_previous_instruction) && reg_write_1st_instruction) begin
            alu_input_2 = 2'b01; // pass the value from ex_mem registe
        end
        else if ((source_register_2 == destination_register_of_2nd_previous_instruction) && reg_write_2nd_instruction) begin
            alu_input_2 = 2'b10; // pass the value from mem_wb registe
        end
        else alu_input_2 = 2'b00; // pass the degault value form the single cycle (alu_source mux output)
    end
    
endmodule