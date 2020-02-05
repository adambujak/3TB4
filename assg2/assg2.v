module assg2 (input wire w, clk, output wire z);
   reg [3:0] w_values;
	assign z = (w_values == 4'b1111 || w_values == 4'b1001); //{w_values[3],w_values[2],w_values[1],w_values[0]
	always @ (posedge clk)
	begin
		w_values = w_values<< 1;
		w_values[0] = w;
	end
endmodule