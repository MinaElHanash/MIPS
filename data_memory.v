module data_memory (
    input memory_read, memory_write, clk,
    input [31:0] read_address, write_address, write_data,
    output reg [31:0] output_data
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

    always @(*) begin

        output_data = 32'd0; // default value to avoid latches

        if (memory_read) begin
            if (actual_read_address > 32'd1023) begin
                output_data = data_memory_registers[1023];
            end
            else begin
                output_data = data_memory_registers[actual_read_address];
            end
        end
    end

    always @(posedge clk) begin // wirte is synchronous to avoid potential errors, as we must make sure that the write address is ready and stable before actually write in it
        if (memory_write) begin
            if (actual_write_address > 32'd1023) begin
                data_memory_registers[1023] <= write_data;
            end
            else begin
                data_memory_registers[actual_write_address] <= write_data;
            end
        end
    end

endmodule