module alu (
    input [31:0] input_1, input_2,
    input [2:0] alu_control,
    output reg [31:0] alu_result,
    output zero_flag, 
    output reg overflow_flag
);
    always @(*)
        begin
            overflow_flag = 1'b0; // default to zero and change to 1 if an overflow is detected
            case (alu_control)
                3'b000: begin
                            alu_result = input_1+input_2; // add

                            if ( (input_1[31] == input_2[31]) & (alu_result[31] != input_1[31]) )
                            // if the inputs are +ve and the result is negative, then overflow, or visversa                                              )
                                begin
                                    overflow_flag = 1'b1;
                                end
                        end                   
                3'b001: begin
                            alu_result = input_1-input_2; // sub

                            if ( (input_1[31] != input_2[31]) & (alu_result[31] == input_2[31]) )
                            // if +ve - -ve equal to -ve, then overflow
                            // if -ve - +ve equal to +ve, then overflow
                                begin
                                    overflow_flag = 1'b1;
                                end
                        end 
                3'b010: alu_result = input_1&input_2; // and
                3'b011: alu_result = input_1|input_2; // or
                3'b100: alu_result = (input_1 < input_2)?32'd1:32'd0; // slt
                default: alu_result = input_1+input_2; // default case is add to avoid latches
            endcase
        end

    assign zero_flag = (alu_result == 32'd0) ? 1'b1 : 1'b0; // zero flag

endmodule