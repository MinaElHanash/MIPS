module mux_2to1_32bits (
    input [31:0] input_1, input_2,
    input select,
    output [31:0] mux_out
);
    
    assign mux_out = select?input_2:input_1;

endmodule