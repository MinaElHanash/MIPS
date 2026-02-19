module hazard_detection_unit (
    input [4:0] id_rs, id_rt, ex_rt,
    input mem_read,
    output reg hazard_flag, if_id_write_enable, pc_write_enable
);
    always @(*) begin
        hazard_flag = 1'b0;
        if_id_write_enable = 1'b1;
        pc_write_enable = 1'b1;

        if (mem_read && ( (id_rs == ex_rt) || (id_rt == ex_rt) ) ) begin
            hazard_flag = 1'b1;
            if_id_write_enable = 1'b0;
            pc_write_enable = 1'b0;
        end

    end
endmodule