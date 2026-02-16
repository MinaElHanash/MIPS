module top_module (
    input clk, reset
);
    //wires declaration

    //pc 
    wire [31:0] next_pc, current_pc, pc_plus_4;
    wire [31:0] branch_result, jump_result;
    
    //instruction memory
    wire [31:0] instruction;

    //register file
    wire [4:0] read_address_1, read_address_2, write_address;
    wire [31:0] reg_out_1,reg_out_2, data_write;

    //control unit
    wire [1:0] register_destination, alu_op;
    wire memory_read, memory_write, reg_write, jump, branch, branch_control, pc_control, memory_read_source;
    wire alu_source, memory_to_register, memory_write_source;

    // alu and alu conrol
    wire [31:0] alu_input_2, alu_result;
    wire [2:0] alu_control;
    wire zero_flag, overflow_flag;

    //data memory and sign extender
    wire [31:0] sing_extended, memory_read_address, memory_write_address, memory_out, mem_write_data;
    wire [31:0] shifted_immediate, branch_target, jump_address; 

    assign shifted_immediate = sing_extended << 2;
    assign jump_address = {pc_plus_4[31:28],instruction[25:0],2'b00};
    assign branch_control = branch&zero_flag;

    // modules instansiation

    program_counter pc (
        .next_pc(next_pc), .clk(clk), .rst(reset), .current_pc(current_pc), .overflow_flag(overflow_flag)
    );

    instruction_memory im (
        .pc(current_pc), .instruction(instruction)
    );

    mux_4to1_5bits mux_4to1 (
        .input_1(instruction[20:16]), .input_2(instruction[15:11]), .input_3(instruction[25:21]), .input_4(5'd0),
        .select(register_destination),
        .mux_out(write_address)
    );

    register_file reg_file (
        .read_address_1(instruction[25:21]),
        .read_address_2(instruction[20:16]),
        .write_address(write_address),
        .write_data(data_write),
        .clk(clk), .rst(reset),
        .reg_write(reg_write),
        .reg_out_1(reg_out_1), .reg_out_2(reg_out_2)
    );

    sign_extender extender (
        .in(instruction[15:0]), .out(sing_extended)
    );

    control_unit control (
        .op_code(instruction[31:26]),
        .register_destination(register_destination), .alu_op(alu_op),
        .jump(jump), .branch(branch), .memory_read(memory_read), .memory_write(memory_write),
        .memory_to_register(memory_to_register), .alu_source(alu_source), .reg_write(reg_write), .pc_control(pc_control),
        .memory_read_source(memory_read_source), .memory_write_source(memory_write_source)
    );

    alu_control_unit alu_control_unit (
        .alu_op(alu_op),
        .alu_control_out(alu_control),
        .funct(instruction[5:0])
    );

    mux_2to1_32bits alu_source_mux (
        .input_1(reg_out_2), .input_2(sing_extended),
        .select(alu_source),
        .mux_out(alu_input_2)
    );

    alu alu_module (
        .input_1(reg_out_1), .input_2(alu_input_2),
        .alu_control(alu_control), 
        .alu_result(alu_result),
        .zero_flag(zero_flag), .overflow_flag(overflow_flag)
    );

    mux_2to1_32bits memory_read_mux (
        .input_1(alu_result), .input_2(reg_out_2),
        .select(memory_read_source),
        .mux_out(memory_read_address)
    );

    mux_2to1_32bits data_write_mux (
        .input_1(reg_out_2), .input_2(pc_plus_4),
        .select(memory_write_source),
        .mux_out(mem_write_data)
    );

    data_memory memory (
        .memory_read(memory_read), .memory_write(memory_write), .clk(clk),
        .read_address(memory_read_address), .write_address(alu_result), .write_data(mem_write_data),
        .output_data(memory_out)
    );

    mux_2to1_32bits memory_to_register_mux (
        .input_1(alu_result), .input_2(memory_out),
        .select(memory_to_register),
        .mux_out(data_write)
    );


    adder adder_1 (
        .input_1(current_pc),
        .input_2(3'b100),
        .adder_output(pc_plus_4)
    );

    adder adder_2 (
        .input_1(pc_plus_4),
        .input_2(shifted_immediate),
        .adder_output(branch_target)
    );
    
    mux_2to1_32bits branch_mux (
        .input_1(pc_plus_4), .input_2(branch_target),
        .select(branch_control),
        .mux_out(branch_result)
    );

    mux_2to1_32bits jump_mux (
        .input_1(branch_result), .input_2(jump_address),
        .select(jump),
        .mux_out(jump_result)
    );

    mux_2to1_32bits pmc (
        .input_1(jump_result), .input_2(memory_out),
        .select(pc_control),
        .mux_out(next_pc)
    );

    // overflow monitoring block
    always @(posedge clk) begin
        if (overflow_flag)
            begin
                $display("-------------------------------------------------------------");
                $display("CRITICAL ERROR: Arithmetic Overflow Detected!");
                $display("Processor Halted at PC = %h", current_pc);
                $display("-------------------------------------------------------------");
                $stop;
            end
    end

endmodule