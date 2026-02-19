module mux_4to1_32bits (
    input [31:0] input_1, input_2, input_3, input_4,
    input [1:0] select,
    output reg [31:0] mux_out
);

    always @(*) begin
        case (select)
            2'b00: mux_out = input_1; // default alu input
            2'b01: mux_out = input_2; // destination register of ex_mem stage
            2'b10: mux_out = input_3; // destination register of mem_wb stage
            2'b11: mux_out = input_4; // 32'd0 for if the destination register was $0
            default: mux_out = input_1; // default alu input
        endcase
    end
endmodule