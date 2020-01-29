module seven_seg_decoder ( input [3:0] SW, input en, output [6:0] HEX0 );
	reg [6:0] reg_LEDs;
	assign HEX0[0]= (SW[2]&(~SW[1])&(~SW[0]) | (~SW[3])&(~SW[2])&(~SW[1])&SW[0] | SW[3]&SW[2]&SW[1]&SW[0] | SW[3]&(~SW[2])&SW[1]&(~SW[0]))&en; 
	assign HEX0[1]= ((~SW[3])&SW[2]&(~SW[1])&SW[0] | (~SW[3])&SW[2]&SW[1]&(~SW[0]) | SW[3]&SW[2]&SW[1]&SW[0] | SW[3]&(~SW[2])&SW[1]&(~SW[0]))&en;

	assign HEX0[6:2]=reg_LEDs[6:2];

	always @(en) begin	
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


module lab1part3 ( input [9:0] SW, output [6:0] HEX0 );
	//if (SW[8] == 1'b0 & SW[9] == 1'b0) //assume 0 is off
	reg en;
	seven_seg_decoder seven_seg (SW[6:0], en, HEX0);
	
	always @(*) begin
		en = 1;
	end
	
//	always @(*) begin
//		case(SW[9:8])
//			2'b00: seven_seg <= 2'b00;
//			2'b01:
//			2'b10:
//			2'b11: 
//	end
	

endmodule
//	else if (SW[9] == 0 & SW[8] == 1)
//	begin
//		//take input from 4 bit counter that takes input from KEY3
//	end
//	else if (SW
