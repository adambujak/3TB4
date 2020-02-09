module d_flip_flop (input d,clk, output reg q, output q_b);
	always @(posedge clk)
	begin
		q<=d;
	end
	assign q_b = ~q;
endmodule