module mux_4to1_5bits (
    input [4:0] input_1, input_2, input_3, input_4,
    input [1:0] select,
    output reg [4:0] mux_out
);

    always @(*) begin
        case (select)
            2'b00: mux_out = input_1; // for I-type
            2'b01: mux_out = input_2; // for R-type
            2'b10: mux_out = input_3; // for swi (custom instruction)
            default: mux_out = input_2; //  default will be like normal I-type
        endcase
    end
endmodule