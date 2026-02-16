module adder (
    input [31:0] input_1, input_2,
    output [31:0] adder_output
);

    assign adder_output = input_1 + input_2;
    
endmodule