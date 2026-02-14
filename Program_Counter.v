module Program_Counter (
    input [31:0] Next_PC,
    input rst, clk,
    output reg [31:0] Current_PC
);
    
    always @(posedge clk or posedge rst) // asynchronous reset, PC will reset regardless of th clk
        begin
            if (rst) 
                begin
                    Current_PC <= 32'd0;
                end
            else 
                begin
                    Current_PC <= Next_PC;
                end
        end

    //Mina

endmodule