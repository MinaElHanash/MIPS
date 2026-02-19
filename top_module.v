module top_module (
    input clk, rst
);
    //**********************************************************
    //wires declaration
    //**********************************************************

    //**********************************************************
    //if stage
    //**********************************************************
    
    wire [31:0] if_current_pc, if_instruction, if_current_pc_plus_4;

    wire [31:0] if_branch_mux_output, if_jump_mux_output, if_pmc_mux_output;

    //**********************************************************
    //id stage
    //**********************************************************
    
    wire [31:0] id_instruction, id_pc, id_pc_plus_4;

    // control signals
    wire [1:0] id_register_destination, id_alu_op;
    wire id_jump, id_branch, id_memory_read, id_memory_write, id_memory_to_register, id_alu_source;
    wire id_reg_write, id_pc_control, id_memory_write_source, id_memory_read_source;

    // register file signals
    wire [31:0] id_register_out_1, id_register_out_2;

    // sign extender signal
    wire [31:0] id_sign_extended;

    // hazard detection signals
    wire id_hazard_flage, id_pc_write_enable, if_id_write_enable;

    // jump signals
    wire [31:0] id_jump_address;
    wire [27:0] id_jump_imm_shifted_by_2;

    //**********************************************************
    //ex stage
    //**********************************************************

    wire [31:0] ex_pc;

    // MUXs inputs
    wire [31:0] ex_mux_1_input_1, ex_mux_1_input_2, ex_mux_1_input_3, ex_mux_1_input_4;
    wire [31:0] ex_mux_2_input_1, ex_mux_2_input_2, ex_mux_2_input_3, ex_mux_2_input_4;
    wire [31:0] ex_alu_source_mux_input_1, ex_alu_source_mux_input_2;

    // MUXs outputs
    wire [31:0] ex_mux_1_output, ex_mux_2_output, ex_alu_source_mux_output;

    // MUXs control signals
    wire ex_alu_source;
    wire [1:0] ex_alu_input_1_select, ex_alu_input_2_select;

    // alu control unit signals
    wire [1:0] ex_alu_op;
    wire [2:0] ex_alu_control;
    wire [5:0] ex_funct;

    // register adresses
    wire [4:0] ex_rt_address, ex_rd_address, ex_rs_address;
    wire [4:0] ex_destination_register;

    // alu signals
    wire [31:0] ex_alu_result;
    wire ex_zero_flag, ex_overflow_flag;

    // branch signals
    wire [31:0] ex_pc_plus_4, ex_imm, ex_imm_shifted_by_2;
    wire [31:0] ex_branch_address;

    // control signals
    wire [1:0] ex_register_destination;
    wire ex_branch, ex_memory_read, ex_memory_write, ex_memory_to_register;
    wire ex_reg_write, ex_pc_control, ex_memory_write_source, ex_memory_read_source;

    //**********************************************************
    //mem stage
    //**********************************************************
    
    wire [31:0] mem_pc;

    // memory MUXs signals
    wire [31:0] mem_alu_result, mem_register_file_output_2, mem_pc_plus_4;
    
    // control signals
    wire mem_branch_control;

    // memory singals
    wire [31:0] mem_memory_read_address, mem_memory_write_data;
    wire [31:0] mem_memory_in_data, mem_memory_out_data;

    // branch address
    wire [31:0] mem_branch_address;

    // control signals
    wire mem_branch, mem_memory_read, mem_memory_write, mem_memory_to_register;
    wire mem_reg_write, mem_pc_control, mem_memory_write_source, mem_memory_read_source;

    wire [4:0] mem_destination_register;
    wire mem_zero_flag, mem_overflow_flag;

    //**********************************************************
    //wb stage
    //**********************************************************

    wire [31:0] wb_pc;

    // memory to register mux signals
    wire [31:0] wb_memory_data, wb_alu_result, wb_register_file_data_wrtie;

    // control signals
    wire wb_memory_to_register;
    wire wb_reg_write;
    wire [4:0] wb_register_destination;

    wire wb_overflow_flag;

    //**********************************************************
    //some assigns
    //**********************************************************

    // jump address
    assign id_jump_imm_shifted_by_2 = {id_instruction[25:0], 2'b00};
    assign id_jump_address = {id_pc_plus_4[31:28], id_jump_imm_shifted_by_2};

    // branch address
    assign ex_imm_shifted_by_2 = {ex_alu_source_mux_input_2[29:0], 2'b00};

    // 4th input for alu
    assign ex_mux_1_input_4 = 32'd0;
    assign ex_mux_2_input_4 = 32'd0;

    // branch control
    assign mem_branch_control = mem_branch & mem_zero_flag;

    // flush signals
    assign mem_stage_flush_trigger = mem_branch_control | mem_pc_control;
    assign if_id_flush = id_jump | mem_stage_flush_trigger;
    assign id_ex_flush = mem_stage_flush_trigger | id_hazard_flage;



    mux_2to1_32bits branch_mux (
        .input_1(if_current_pc_plus_4), .input_2(mem_branch_address),
        .select(mem_branch_control),
        .mux_out(if_branch_mux_output)
    );

    mux_2to1_32bits jump_mux (
        .input_1(if_branch_mux_output), .input_2(id_jump_address),
        .select(id_jump),
        .mux_out(if_jump_mux_output)
    );

    mux_2to1_32bits pmc_mux (
        .input_1(if_jump_mux_output), .input_2(mem_memory_out_data),
        .select(mem_pc_control),
        .mux_out(if_pmc_mux_output)
    );

    program_counter program_counter_module (
        .next_pc(if_pmc_mux_output),
        .clk(clk), .rst(rst), .overflow_flag(wb_overflow_flag), .write_enable(id_pc_write_enable),
        .current_pc(if_current_pc)
    );

    instruction_memory instruction_memory_module (
        .pc(if_current_pc),
        .instruction(if_instruction)
    );

    adder pc_adder_module (
        .input_1(32'd4), .input_2(if_current_pc),  
        .adder_output(if_current_pc_plus_4)
    );

    if_id_stage if_id_stage_register (
        .clk(clk), .rst(rst),
        .write_enable(if_id_write_enable), .flush(if_id_flush),
        .instruction_in(if_instruction), .pc_in(if_current_pc), .pc_plus_4_in(if_current_pc_plus_4),
        .instruction_out(id_instruction), .pc_out(id_pc), .pc_plus_4_out(id_pc_plus_4)
    );

    register_file register_file_module (
        .read_address_1(id_instruction[25:21]), .read_address_2(id_instruction[20:16]),
        .write_address(wb_register_destination), .write_data(wb_register_file_data_wrtie),
        .reg_write(wb_reg_write), .clk(clk), .rst(rst),
        .reg_out_1(id_register_out_1), .reg_out_2(id_register_out_2)
    );

    sign_extender sign_extender_module (
        .in(id_instruction[15:0]), .out(id_sign_extended)
    );

    control_unit control_unit_module (
        .op_code(id_instruction[31:26]),
        .register_destination(id_register_destination), .alu_op(id_alu_op),
        .jump(id_jump), .branch(id_branch), .memory_read(id_memory_read),
        .memory_write(id_memory_write), .memory_to_register(id_memory_to_register), 
        .alu_source(id_alu_source), .reg_write(id_reg_write), .pc_control(id_pc_control), 
        .memory_write_source(id_memory_write_source), .memory_read_source(id_memory_read_source)
    );

    hazard_detection_unit hazard_detection_unit_module (
        .id_rs(id_instruction[25:21]), .id_rt(id_instruction[20:16]), .ex_rt(ex_rt_address),
        .mem_read(ex_memory_read),
        .hazard_flag(id_hazard_flage), .if_id_write_enable(if_id_write_enable), .pc_write_enable(id_pc_write_enable)
    );

    id_ex_stage id_ex_stage_register (
        //*******************************************
        //inputs
        //*******************************************

        // system signals
        .clk(clk), .rst(rst),
        .flush(id_ex_flush),

        // data signals
        .pc_in(id_pc), .pc_plus_4_in(id_pc_plus_4), .reg_file_out_1_in(id_register_out_1),
        .reg_file_out_2_in(id_register_out_2), .sign_extended_in(id_sign_extended),
        .reg_rs_address_in(id_instruction[25:21]), .reg_rt_address_in(id_instruction[20:16]),
        .reg_rd_address_in(id_instruction[15:11]), .funct_in(id_instruction[5:0]),

        // control signals
        .register_destination_in(id_register_destination), .alu_op_in(id_alu_op),
        .branch_in(id_branch), .memory_read_in(id_memory_read),
        .memory_write_in(id_memory_write), .memory_to_register_in(id_memory_to_register),
        .alu_source_in(id_alu_source), .reg_write_in(id_reg_write), .pc_control_in(id_pc_control),
        .memory_write_source_in(id_memory_write_source), .memory_read_source_in(id_memory_read_source),

        //*******************************************
        // outputs
        //*******************************************

        // data signals
        .pc_out(ex_pc), .pc_plus_4_out(ex_pc_plus_4), .reg_file_out_1_out(ex_mux_1_input_1),
        .reg_file_out_2_out(ex_alu_source_mux_input_1), .sign_extended_out(ex_alu_source_mux_input_2),
        .reg_rs_address_out(ex_rs_address), .reg_rt_address_out(ex_rt_address),
        .reg_rd_address_out(ex_rd_address), .funct_out(ex_funct),

        // control signals
        .register_destination_out(ex_register_destination), .alu_op_out(ex_alu_op),
        .branch_out(ex_branch), .memory_read_out(ex_memory_read),
        .memory_write_out(ex_memory_write), .memory_to_register_out(ex_memory_to_register),
        .alu_source_out(ex_alu_source), .reg_write_out(ex_reg_write), .pc_control_out(ex_pc_control),
        .memory_write_source_out(ex_memory_write_source), .memory_read_source_out(ex_memory_read_source)
    );

    adder branch_adder_module (
        .input_1(ex_pc_plus_4), .input_2(ex_imm_shifted_by_2),  
        .adder_output(ex_branch_address)
    );

    mux_4to1_32bits alu_input_1_mux (
        .input_1(ex_mux_1_input_1), .input_2(ex_mux_1_input_2),
        .input_3(ex_mux_1_input_3), .input_4(ex_mux_1_input_4),
        .select(ex_alu_input_1_select),
        .mux_out(ex_mux_1_output)
    );

    mux_2to1_32bits alu_source_mux (
        .input_1(ex_alu_source_mux_input_1), .input_2(ex_alu_source_mux_input_2),
        .select(ex_alu_source),
        .mux_out(ex_mux_2_input_1)
    );

    mux_4to1_32bits alu_input_2_mux (
        .input_1(ex_mux_2_input_1), .input_2(ex_mux_2_input_2),
        .input_3(ex_mux_2_input_3), .input_4(ex_mux_2_input_4),
        .select(ex_alu_input_2_select),
        .mux_out(ex_mux_2_output)
    );

    alu alu_module (
        .input_1(ex_mux_1_output), .input_2(ex_mux_2_output),
        .alu_control(ex_alu_control),
        .alu_result(ex_alu_result),
        .zero_flag(ex_zero_flag), 
        .overflow_flag(ex_overflow_flag)
    );

    alu_control_unit alu_control_unit_module (
        .alu_op(ex_alu_op),
        .funct(ex_funct),
        .alu_control_out(ex_alu_control)
    );

    mux_4to1_5bits destination_register_mux (
        .input_1(ex_rt_address), .input_2(ex_rd_address),
        .input_3(ex_rs_address), .input_4(5'd0),
        .select(ex_register_destination),
        .mux_out(ex_destination_register)
    );

    forwarding_unit forwarding_unit_module (
        .destination_register_of_1st_previous_instruction(mem_destination_register),
        .destination_register_of_2nd_previous_instruction(wb_register_destination),
        .source_register_1(ex_rs_address), .source_register_2(ex_rt_address),
        .reg_write_1st_instruction(mem_reg_write), .reg_write_2nd_instruction(wb_reg_write),

        .alu_input_1(ex_alu_input_1_select), .alu_input_2(ex_alu_input_2_select)
    );

    ex_mem_stage ex_mem_stage_register (
        //*******************************************
        //inputs
        //*******************************************

        .clk(clk), .rst(rst), .flush(mem_stage_flush_trigger),
        .branch_target_in(ex_branch_address), .pc_in(ex_pc), .pc_plus_4_in(ex_pc_plus_4),
        .alu_result_in(ex_alu_result), .reg_file_out_2_in(ex_alu_source_mux_input_1),
        .register_destination_in(ex_register_destination),
        .zero_flag_in(ex_zero_flag), .overflow_flag_in(ex_overflow_flag),

        // control signals
        .branch_in(ex_branch), .memory_read_in(ex_memory_read),
        .memory_write_in(ex_memory_write), .memory_to_register_in(ex_memory_to_register),
        .reg_write_in(ex_reg_write), .pc_control_in(ex_pc_control),
        .memory_write_source_in(ex_memory_write_source), .memory_read_source_in(ex_memory_read_source),

        //*******************************************
        // outputs
        //*******************************************

        .branch_target_out(mem_branch_address), .pc_out(mem_pc), .pc_plus_4_out(mem_pc_plus_4),
        .alu_result_out(mem_alu_result), .reg_file_out_2_out(mem_register_file_output_2),
        .register_destination_out(mem_destination_register),
        .zero_flag_out(mem_zero_flag), .overflow_flag_out(mem_overflow_flag),

        // control signals
        .branch_out(mem_branch), .memory_read_out(mem_memory_read),
        .memory_write_out(mem_memory_write), .memory_to_register_out(mem_memory_to_register),
        .reg_write_out(mem_reg_write), .pc_control_out(mem_pc_control),
        .memory_write_source_out(mem_memory_write_source), .memory_read_source_out(mem_memory_read_source)
    );

    mux_2to1_32bits memory_read_source_mux (
        .input_1(mem_alu_result), .input_2(mem_register_file_output_2),
        .select(mem_memory_read_source),
        .mux_out(mem_memory_read_address)
    );

    mux_2to1_32bits memory_data_write_source_mux (
        .input_1(mem_register_file_output_2), .input_2(mem_pc_plus_4),
        .select(mem_memory_write_source),
        .mux_out(mem_memory_write_data)
    );

    data_memory data_memory_module (
        .memory_read(mem_memory_read), .memory_write(mem_memory_write), .clk(clk),
        .read_address(mem_memory_read_address), .write_address(mem_alu_result),
        .write_data(mem_memory_write_data),
        .output_data(mem_memory_out_data)
    );

    mem_wb_stage mem_wb_stage_register (
        //*******************************************
        //inputs
        //*******************************************

        .clk(clk), .rst(rst),

        .pc_in(mem_pc),

        // data signals
        .memory_data_in(mem_memory_out_data), .alu_result_in(mem_alu_result),
        .register_destination_in(mem_destination_register),

        // control signals
        .memory_to_register_in(mem_memory_to_register), .reg_write_in(mem_reg_write),
        .overflow_flag_in(mem_overflow_flag),

        //*******************************************
        //outputs
        //*******************************************
        
        .pc_out(wb_pc),

        // data signals
        .memory_data_out(wb_memory_data), .alu_result_out(wb_alu_result),
        .register_destination_out(wb_register_destination),

        // control signals
        .memory_to_register_out(wb_memory_to_register), .reg_write_out(wb_reg_write),
        .overflow_flag_out(wb_overflow_flag)
    );

    mux_2to1_32bits data_to_register_mux (
        .input_1(wb_alu_result), .input_2(wb_memory_data),
        .select(wb_memory_to_register),
        .mux_out(wb_register_file_data_wrtie)
    );

    // overflow monitoring block
    always @(posedge clk) begin
        if (wb_overflow_flag) begin
            $display("-------------------------------------------------------------");
            $display("CRITICAL ERROR: Arithmetic Overflow Detected!");
            $display("Processor Halted at Faulting PC = %h", wb_pc);
            $display("-------------------------------------------------------------");
            $stop; 
        end
    end

endmodule