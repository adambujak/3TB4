

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
		if (br)
		begin
			alu_set_low_reg = 1'b1;
		end
	end
endmodule

