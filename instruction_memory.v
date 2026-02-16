module instruction_memory (
    input [31:0] pc,
    output [31:0] instruction
);
    wire [31:0] pc_by_4; // as address 1 in IM is equal to "pc = 4"
    // in other words, MIPS is byte aligned and each word is 4 bytes

    reg [31:0] instruction_memory_registers [0:255];
    
    assign pc_by_4 = pc >> 2;
    assign instruction = instruction_memory_registers [pc_by_4];

    initial // load "program.hex" into the instruction memory
        begin
            $readmemh("program.hex", instruction_memory_registers );
        end

endmodule
