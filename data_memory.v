module data_memory (
    input memory_read, memory_write, clk,
    input [31:0] read_address, write_address, write_data,
    output [31:0] output_data
);

    wire [31:0] actual_read_address, actual_write_address; 

    // as each word (register) holds 4 bytes
    // in other words, MIPS is byte aligned and each word is 4 bytes, so address if the alu result is 8, then this is the 2nd regiter and not the 8th
    assign actual_read_address = read_address >> 2;
    assign actual_write_address = write_address >> 2;

    reg [31:0] data_memory_registers [0:1023];

    initial // load "data.hex" into the data memory
        begin
            $readmemh("data.hex", data_memory_registers );
        end


    assign output_data = (memory_read)?data_memory_registers[actual_read_address]:32'd0;
    // asynchronous for speed and because if we read on the posedge of the clk there will be no time to write back in the register file or to write in pc fpr pmc instruction

    always @(posedge clk) begin // wirte is synchronous to avoid potential errors, as we must make sure that the write address is ready and stable before actually write in it
        if (memory_write) begin
            data_memory_registers[actual_write_address] <= write_data;
        end
    end

endmodule