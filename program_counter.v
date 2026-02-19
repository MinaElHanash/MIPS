module program_counter (
    input [31:0] next_pc,
    input rst, clk, overflow_flag, write_enable,
    output reg [31:0] current_pc
);
    
    always @(posedge clk or posedge rst) // asynchronous reset, PC will reset regardless of th clk
        begin
            if (rst) 
                begin
                    current_pc <= 32'd0;
                end
            else if (overflow_flag) 
                begin
                    current_pc <= current_pc;
                end
            else if (write_enable) begin
                current_pc <= next_pc;
            end
            else 
                begin
                    current_pc <= current_pc;
                end
        end

endmodule