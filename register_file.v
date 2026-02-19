module register_file (
    input [4:0] read_address_1, read_address_2, write_address,
    input [31:0] write_data,
    input reg_write, clk, rst,
    output [31:0] reg_out_1, reg_out_2
);
    reg [31:0] registers [0:31]; // 32 register each with width of 32 bit
    integer i; //  used in the for loop for clearing the content ot the registers


    always @(posedge clk)
        begin
            if (rst) // reset the content of all register to zero
                begin
                    for (i = 1 ; i<32 ; i = i+1 ) begin
                        registers[i] <= 32'd0;
                    end
                end
            else if (reg_write && (write_address!= 5'd0)) // write if it is not the 0th register
                begin
                    registers[write_address] <= write_data;
                end
        end

    // hard wire the 0th register to zero
    assign reg_out_1 = (read_address_1 == 5'd0) ? 32'd0 : registers[read_address_1];
    assign reg_out_2 = (read_address_2 == 5'd0) ? 32'd0 : registers[read_address_2];

endmodule