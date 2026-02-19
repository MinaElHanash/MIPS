module control_unit (
    input [5:0] op_code,
    output reg [1:0] register_destination, alu_op,
    output reg jump, branch, memory_read, memory_write, memory_to_register, alu_source,
    output reg reg_write, pc_control, memory_write_source, memory_read_source
);
    always @(*) begin

        // initialize everything to zero
        register_destination = 2'b00;
        alu_op = 2'b00;
        jump = 1'b0;
        branch = 1'b0;
        memory_read = 1'b0;
        memory_write = 1'b0;
        memory_to_register = 1'b0;
        alu_source = 1'b0;
        reg_write = 1'b0;
        pc_control = 1'b0;
        memory_write_source = 1'b0;
        memory_read_source = 1'b0;

        case (op_code)

            6'b000000: begin // all R-type instructions
                alu_op = 2'b10;
                reg_write = 1'b1;
                register_destination = 2'b01;
            end

            6'b100011: begin // lw instruction
                alu_source = 1'b1;
                memory_read = 1'b1;
                memory_to_register = 1'b1;
                reg_write = 1'b1;
            end

            6'b101011: begin // sw instruction
                memory_write = 1'b1;
                alu_source = 1'b1;
            end

            6'b000100: begin // branch instruction
                branch = 1'b1;
                alu_op = 2'b01;
            end

            6'b001000: begin // addi instruction
                alu_source = 1'b1;
                reg_write = 1'b1;
                alu_op = 2'b00; // force add, it is 00 by default but i add it anyways to show that we treat addi as a normal add instruction
            end

            6'b001100: begin // andi instruction
                alu_source = 1'b1;
                alu_op = 2'b11;
                reg_write = 1'b1;
            end

            6'b000010: begin // jump instruction
                jump = 1'b1;
            end

            // custom instructions

            6'b110000: begin // jump mem indirect instruction
                alu_source = 1'b1;
                memory_read = 1'b1;
                alu_op = 2'b00; // force add
                pc_control = 1'b1;
            end

            6'b110001: begin // store and increment instruction
                alu_source = 1'b1;
                register_destination = 2'b10;
                reg_write = 1'b1;
                memory_write = 1'b1;
            end

            6'b110010: begin // program mem copy instruction
                alu_source = 1'b1;
                pc_control = 1'b1;
                memory_read = 1'b1;
                memory_write = 1'b1;
                memory_write_source = 1'b1;
                memory_read_source = 1'b1;
            end

        endcase

    end
endmodule