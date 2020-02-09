module d_latch ( input data, en, output reg q, output q_not );
always @(en or data)
	begin
		if (en)
		begin
			q <= data;
		end
	end
	assign q_not = ~q;
endmodule