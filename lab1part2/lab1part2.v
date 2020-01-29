//module seven_seg_decoder ( input [3:0] SW, output [6:0] HEX0 );
//	reg [6:0] reg_LEDs;
//	assign HEX0[0]= SW[2]&(~SW[1])&(~SW[0]) | (~SW[3])&(~SW[2])&(~SW[1])&SW[0] | SW[3]&SW[2]&SW[1]&SW[0] | SW[3]&(~SW[2])&SW[1]&(~SW[0]); 
//	assign HEX0[1]= (~SW[3])&SW[2]&(~SW[1])&SW[0] | (~SW[3])&SW[2]&SW[1]&(~SW[0]) | SW[3]&SW[2]&SW[1]&SW[0] | SW[3]&(~SW[2])&SW[1]&(~SW[0]);
//
//	assign HEX0[6:2]=reg_LEDs[6:2];
//
//	always @(*) begin	
//		case (SW) 
//			4'b0000: reg_LEDs[6:2]<=5'b10000;
//			4'b0001: reg_LEDs[6:2]<=5'b11110;
//			4'b0010: reg_LEDs[6:2]<=5'b01001;
//			4'b0011: reg_LEDs[6:2]<=5'b01100;
//			4'b0100: reg_LEDs[6:2]<=5'b00110; 
//			4'b0101: reg_LEDs[6:2]<=5'b00100; 
//			4'b0110: reg_LEDs[6:2]<=5'b00000; 
//			4'b0111: reg_LEDs[6:2]<=5'b11110;
//			4'b1000: reg_LEDs[6:2]<=5'b00000;
//			4'b1001: reg_LEDs[6:2]<=5'b00100;
//			4'b1010: reg_LEDs[6:2]<=5'b10001; 
//			4'b1011: reg_LEDs[6:2]<=5'b00010;
//			4'b1100: reg_LEDs[6:2]<=5'b10000; 
//			4'b1101: reg_LEDs[6:2]<=5'b10011;
//			4'b1110: reg_LEDs[6:2]<=5'b00010;
//			4'b1111: reg_LEDs[6:2]<=5'b11111; 
//		endcase
//	end
//endmodule
//
//
//module lab1part2 ( input [3:0] SW, output [6:0] HEX0 );
//	seven_seg_decoder seven_seg ( SW, HEX0 );
//endmodule

module seven_seg_decoder ( input [3:0] SW, output [6:0] HEX0 );
	reg [6:0] reg_LEDs;
	assign HEX0[0]= (SW[2]&(~SW[1])&(~SW[0]) | (~SW[3])&(~SW[2])&(~SW[1])&SW[0] | SW[3]&SW[2]&SW[1]&SW[0] | SW[3]&(~SW[2])&SW[1]&(~SW[0])); 
	assign HEX0[1]= ((~SW[3])&SW[2]&(~SW[1])&SW[0] | (~SW[3])&SW[2]&SW[1]&(~SW[0]) | SW[3]&SW[2]&SW[1]&SW[0] | SW[3]&(~SW[2])&SW[1]&(~SW[0]));

	assign HEX0[6:2]=reg_LEDs[6:2];

	always @(*) begin	
			case (SW) 
				4'b0000: reg_LEDs[6:2]<=5'b10000;
				4'b0001: reg_LEDs[6:2]<=5'b11110;
				4'b0010: reg_LEDs[6:2]<=5'b01001;
				4'b0011: reg_LEDs[6:2]<=5'b01100;
				4'b0100: reg_LEDs[6:2]<=5'b00110; 
				4'b0101: reg_LEDs[6:2]<=5'b00100; 
				4'b0110: reg_LEDs[6:2]<=5'b00000; 
				4'b0111: reg_LEDs[6:2]<=5'b11110;
				4'b1000: reg_LEDs[6:2]<=5'b00000;
				4'b1001: reg_LEDs[6:2]<=5'b00100;
				4'b1010: reg_LEDs[6:2]<=5'b10001; 
				4'b1011: reg_LEDs[6:2]<=5'b00010;
				4'b1100: reg_LEDs[6:2]<=5'b10000; 
				4'b1101: reg_LEDs[6:2]<=5'b10011;
				4'b1110: reg_LEDs[6:2]<=5'b00010;
				4'b1111: reg_LEDs[6:2]<=5'b11111; 
			endcase
	end
endmodule

module counter4(input clk, reset_n, enable, output reg [WIDTH-1:0] result);
	parameter WIDTH=4;
	//2’s power of 26 is 67,108,864.
	//that is ~1 second (more than 1 second), if count using CLOCK_50.
	always @(posedge clk, negedge reset_n)
		if (!reset_n)
			result<=4'b0;
		else if (enable)
			result<=result+1'b1;
endmodule

module counter30(input clk, reset_n, enable, output reg [WIDTH-1:0] result);
	parameter WIDTH=30;
	//2’s power of 26 is 67,108,864.
	//that is ~1 second (more than 1 second), if count using CLOCK_50.
	always @(posedge clk, negedge reset_n)
		if (!reset_n)
			result<=30'b0;
		else if (enable)
			result<=result+1'b1;
endmodule


module lab1part2 ( input [9:0] SW, input [3:0] KEY, input clk, output [6:0] HEX0 );
	//if (SW[8] == 1'b0 & SW[9] == 1'b0) //assume 0 is off
	reg en;
	reg [3:0] sevenSegInput;
	wire [3:0] count_four_result;
	wire [29:0] count_thirty_result;
	seven_seg_decoder seven_seg (sevenSegInput, HEX0);
	counter4 count_four (KEY[3], KEY[0], en, count_four_result);
	counter30 count_thirty (clk, KEY[0], en, count_thirty_result);
	
	
	always @(*) begin
		en = 1; 
		case(SW[9:8])
			2'b00: sevenSegInput <= {SW[3],SW[2],SW[1],SW[0]};
			2'b01: sevenSegInput <= count_four_result[3:0]; // 4 bit counter from KEY3
			2'b10: sevenSegInput <= count_thirty_result[29:26]; // 30 bit counter counting CLOCK_50
			2'b11: sevenSegInput <= 4'b1111;
		endcase
	end
	

endmodule
//	else if (SW[9] == 0 & SW[8] == 1)
//	begin
//		//take input from 4 bit counter that takes input from KEY3
//	end
//	else if (SW
