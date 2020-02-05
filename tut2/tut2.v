module clock_divider (input Clock, Reset_n, output reg clk_ms);
	parameter factor=20; //50000; // 32’h000061a7;
	reg [31:0] countQ;
	always @ (posedge Clock, negedge Reset_n)
	begin
		if (!Reset_n) 
		begin
			countQ = 0;
		end
		else
		begin  
			if (countQ<factor/2)
			begin
				clk_ms = 1;
			end
			else if (countQ<factor)
			begin
				 clk_ms = 0;
			end
			else //countQ==factor
			begin
				 countQ = 0;
				 clk_ms = 1;
			end
			countQ = countQ + 1;      
		end
	end
endmodule

module hex_to_bcd_converter(input wire clk, reset, input wire [19:0] hex_number, output [3:0] bcd_digit_0,bcd_digit_1,bcd_digit_2,bcd_digit_3, bcd_digit_4,bcd_digit_5);
	// DE1-SoC has 6 7_seg_LEDs, 20 bits can represent decimal 999999.
	//This module is designed to convert a 20 bit binary representation
	//to BCD
	integer i, k;
	wire [19:0] hex_number1; // the last 20 bits of input hex_number
	reg [3:0] bcd_digit [5:0]; //simplifies program
	assign hex_number1=hex_number[19:0];
	assign bcd_digit_0=bcd_digit[0];
	assign bcd_digit_1=bcd_digit[1];
	assign bcd_digit_2=bcd_digit[2];
	assign bcd_digit_3=bcd_digit[3];
	assign bcd_digit_4=bcd_digit[4];
	assign bcd_digit_5=bcd_digit[5];
	always @ (*)
	begin
	//set all 6 digits to 0
	/* fill your code here */
	//shift 20 times
	for (i=19; i>=0; i=i-1)
	begin
	//check all 6 BCD tetrads, if >=5 then add 3
	for (k=5; k>=0; k=k-1)
	begin
	/* fill your code here */
	end
	//shift one bit of BIN/HEX left
	//for the first 5 tetrads
	for (k=5; k>=1; k=k-1)
	begin
	bcd_digit[k]=bcd_digit[k] << 1;
	bcd_digit[k][0]=bcd_digit[k-1][3];
	end
	//shift one bit of BIN/HEX left, for the last tetrad
	/* fill your code here */
	end //end for loop
	end //end of always.
endmodule

module lab2tut (input CLOCK_50, input [2:0] KEY, output [6:0] HEX0, HEX1, HEX2,HEX3, HEX4, HEX5);
	wire clk_en;
	wire [19:0] ms;
	wire [3:0] digit0,digit1,digit2,digit3, digit4,digit5;

	clock_divider #(.factor(50000)) (.Clock(CLOCK_50), .Reset_n(KEY[0]), .Pulse_ms(clk_en));

	counter(.clk(clk_en), .reset_n(KEY[0]), .start_n(KEY[1]), .stop_n(KEY[2]), .ms_count(ms));

	hex_to_bcd_converter(CLOCK_50, KEY[0], ms, digit0,digit1,digit2,digit3, digit4,digit5);

	seven_seg_decoder decoder0(digit0, HEX0);


endmodule