module lab5 (
input wire
        br,
        brz, 
        addi,
        subi,
        sr0,
        srh0,
        clr, 
        mov,
        mova,
        movr,
        movrhs,
        pause,
        register_is_zero,
        delay_done,
        temp_is_positive,
        temp_is_negative, 
        temp_is_zero,
output wire 
        commit_branch,
        increment_pc, 
        write_reg_file,
        start_delay_counter,
        enable_delay_counter,
        load_temp,
        increment_temp,
        decrement_temp,
        alu_set_low,
        alu_set_high,
        alu_add_sub,
        result_mux_select,
output wire [1:0]
        select_immediate,
        select_write_address,
        op1_mux_select,
        op2_mux_select
);

    reg pause_delay;
    reg [1:0] movhrs_stage;
    reg [1:0] movr_stage;

    reg commit_branch_reg;
    reg increment_pc_reg; 
    reg write_reg_file_reg;
    reg start_delay_counter_reg;
    reg enable_delay_counter_reg;
    reg load_temp_reg;
    reg increment_temp_reg;
    reg decrement_temp_reg;
    reg alu_set_low_reg;
    reg alu_set_high_reg;
    reg alu_add_sub_reg;
    reg result_mux_select_reg;

    reg [1:0] select_immediate_reg;
    reg [1:0] select_write_address_reg;
    reg [1:0] op1_mux_select_reg;
    reg [1:0] op2_mux_select_reg;

    
    assign commit_branch        = commit_branch_reg;
    assign increment_pc         = increment_pc_reg; 
    assign write_reg_file       = write_reg_file_reg;
    assign start_delay_counter  = start_delay_counter_reg;
    assign enable_delay_counter = enable_delay_counter_reg;
    assign load_temp            = load_temp_reg;
    assign increment_temp       = increment_temp_reg;
    assign decrement_temp       = decrement_temp_reg;
    assign alu_set_low          = alu_set_low_reg;
    assign alu_set_high         = alu_set_high_reg;
    assign alu_add_sub          = alu_add_sub_reg;
    assign result_mux_select    = result_mux_select_reg;
    assign select_immediate     = select_immediate_reg;
    assign select_write_address = select_write_address_reg;
    assign op1_mux_select       = op1_mux_select_reg;
    assign op2_mux_select       = op2_mux_select_reg;



    always @ (*)
    begin

        if ( pause_delay == 1'b0 )
        begin
            pause_delay = 1'b0;
        end

        if ( movhrs_stage == 2'b00 )
        begin
            pause_delay = 2'b00;
        end
		  
        if ( movr_stage == 2'b00 )
        begin
            pause_delay = 2'b00;
        end

        commit_branch_reg = 1'b0;
        increment_pc_reg = 1'b0; 
        write_reg_file_reg = 1'b0;
        start_delay_counter_reg = 1'b0;
        enable_delay_counter_reg = 1'b0;
        load_temp_reg = 1'b0;
        increment_temp_reg = 1'b0;
        decrement_temp_reg = 1'b0;
        alu_set_low_reg = 1'b0;
        alu_set_high_reg = 1'b0;
        alu_add_sub_reg = 1'b0;
        result_mux_select_reg = 1'b0;

        select_immediate_reg = 2'b00;
        select_write_address_reg = 2'b00;
        op1_mux_select_reg = 2'b00;
        op2_mux_select_reg = 2'b00;
        if ( br )
        begin
            op1_mux_select_reg       = 2'b00;
            op2_mux_select_reg       = 2'b01;
            select_immediate_reg     = 2'b10; 
            alu_add_sub_reg          = 1'b0;
            result_mux_select_reg    = 1'b1;
            select_write_address_reg = 2'b00;
            write_reg_file_reg       = 1'b1;
            commit_branch_reg        = 1'b1;
        end

        if ( brz )
        begin
            if ( register_is_zero )
            begin
                op1_mux_select_reg       = 2'b00;
                op2_mux_select_reg       = 2'b01;
                select_immediate_reg     = 2'b10; 
                alu_add_sub_reg          = 1'b0;
                commit_branch_reg        = 1'b1;
            end
            else
            begin 
                increment_pc_reg = 1'b1;
            end
        end

        if (mov)
        begin
            op1_mux_select_reg = 2'b01;
            op2_mux_select_reg = 2'b00;
            alu_set_low_reg = 1'b1;
            result_mux_select_reg = 1'b1;
            select_write_address_reg = 2'b01; 
            write_reg_file_reg = 1'b1;
            increment_pc_reg = 1'b1;
        end
        if (srh0)
        begin
            op1_mux_select_reg = 2'b11;
            op2_mux_select_reg = 2'b01;
            select_immediate_reg = 2'b01; 
            alu_set_high_reg = 1'b1;;
            result_mux_select_reg = 1'b1;
            select_write_address_reg = 2'b00;
            write_reg_file_reg = 1'b1;
            increment_pc_reg = 1'b1;
        end
        if (sr0)
        begin
            op1_mux_select_reg = 2'b11;
            op2_mux_select_reg = 2'b01;
            select_immediate_reg = 2'b01;
            alu_set_low_reg = 1'b1;;
            result_mux_select_reg = 1'b1;
            select_write_address_reg = 2'b00;
            write_reg_file_reg = 1'b1;
            increment_pc_reg = 1'b1;
        end
        if ( subi )
        begin
            op1_mux_select_reg = 2'b01;
            op2_mux_select_reg = 2'b01;
            select_immediate_reg = 2'b00; 
            alu_add_sub_reg = 1'b1;
            result_mux_select_reg = 1'b1;
            select_write_address_reg = 2'b01;
            write_reg_file_reg = 1'b1;
            increment_pc_reg = 1'b1;
        end
        if ( addi )
        begin
            op1_mux_select_reg = 2'b01;
            op2_mux_select_reg = 2'b01;
            select_immediate_reg = 2'b00; 
            alu_add_sub_reg = 1'b0;
            result_mux_select_reg = 1'b1;
            select_write_address_reg = 2'b01;
            write_reg_file_reg = 1'b1;
            increment_pc_reg = 1'b1;
        end
        if ( clr )
        begin
            result_mux_select_reg = 1'b0; 
            select_write_address_reg = 2'b00; 
            write_reg_file_reg = 1'b1;
            increment_pc_reg = 1'b1;
        end
        if ( pause )
        begin
            if (pause_delay == 1'b0)
            begin
                start_delay_counter_reg = 1'b1;
                pause_delay = 1'b1;
            end
            else 
            begin
                enable_delay_counter_reg = 1'b1;
                if (delay_done)
                begin 
                    increment_pc_reg = 1'b1;
                    pause_delay = 1'b0;
                end
            end
        end
        if ( movrhs )
        begin

            if ( movhrs_stage == 2'b00 )
            begin
                load_temp_reg = 1'b1;
                movhrs_stage = 1'b1;
            end

            else if ( movhrs_stage == 2'b01 )
            begin
                if (temp_is_zero)
                begin
                    increment_pc_reg = 1'b1;
                    movhrs_stage = 2'b10;
                end
                else
                begin 
                    start_delay_counter_reg = 1'b1;
                end
                if (temp_is_positive)
                begin
                    decrement_temp_reg = 1'b1;
                    op1_mux_select_reg = 2'b10;
                    op2_mux_select_reg = 2'b10;
                    alu_add_sub_reg = 1'b0;
                    result_mux_select_reg = 1'b1;
                    select_write_address_reg = 2'b11;
                    write_reg_file_reg = 1'b1;
                end
                if (temp_is_negative)
                begin
                    increment_temp_reg = 1'b1;
                    op1_mux_select_reg = 2'b10;
                    op2_mux_select_reg = 2'b10;
                    alu_add_sub_reg = 1'b1;
                    result_mux_select_reg = 1'b1;
                    select_write_address_reg = 2'b11;
                    write_reg_file_reg = 1'b1;
                end
            end

            else if ( movhrs_stage == 2'b10 )
            begin
                enable_delay_counter_reg = 1'b1;
                movhrs_stage = 2'b00;
            end
        end

        if ( movr )
        begin

            if ( movr_stage == 2'b00 )
            begin
                load_temp_reg = 1'b1;
                movr_stage = 2'b01;
            end

            else if ( movr_stage == 2'b01 )
            begin
                if (temp_is_zero)
                begin
                    increment_pc_reg = 1'b1;
                    movr_stage = 2'b10;
                end
                else
                begin 
                    start_delay_counter_reg = 1'b1;
                end
                if (temp_is_positive)
                begin
                    decrement_temp_reg = 1'b1;
                    op1_mux_select_reg = 2'b10;
                    op2_mux_select_reg = 2'b11;
                    alu_add_sub_reg = 1'b0;
                    result_mux_select_reg = 1'b1;
                    select_write_address_reg = 2'b11;
                    write_reg_file_reg = 1'b1;
                end
                if (temp_is_negative)
                begin
                    increment_temp_reg = 1'b1;
                    op1_mux_select_reg = 2'b10;
                    op2_mux_select_reg = 2'b11;
                    alu_add_sub_reg = 1'b1;
                    result_mux_select_reg = 1'b1;
                    select_write_address_reg = 2'b11;
                    write_reg_file_reg = 1'b1;
                end
            end

            else if ( movr_stage == 2'b10 )
            begin
                enable_delay_counter_reg = 1'b1;
                movr_stage = 2'b00;
            end
        end

    end
endmodule

