module alu_control_unit (
    input [1:0] alu_op,
    input [5:0] funct,
    output reg [2:0] alu_control_out
);

    always @(*)
        begin
            case (alu_op)
                2'b00: alu_control_out = 3'b000; // add, force add for lw and sw instructions
                2'b01: alu_control_out = 3'b001; // sub, force sub for branch instruction
                2'b10:  
                    begin
                        case (funct)
                            6'b100000: alu_control_out = 3'b000; // add
                            6'b100010: alu_control_out = 3'b001; // sub
                            6'b100100: alu_control_out = 3'b010; // and
                            6'b100101: alu_control_out = 3'b011; // or
                            6'b101010: alu_control_out = 3'b100; // slt
                            default: alu_control_out = 3'b000; // add
                        endcase
                    end
                default: alu_control_out = 3'b000; // add
            endcase
        end

endmodule