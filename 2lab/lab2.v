module random (input clk, reset_n, resume_n, output reg [13:0] random,
	output reg rnd_ready);
	//for 14 bits Liner Feedback Shift Register,
	//the Taps that need to be XNORed are: 14, 5, 3, 1
	wire xnor_taps, and_allbits, feedback;
	reg [13:0] reg_values;
	reg enable=1;
	initial
	begin
		reg_values=14'b11111111111111;
		//the LFSR cannot be all 0 at beginning.
		enable=1;
		rnd_ready=0;
	end
	always @ (posedge clk, negedge reset_n, negedge resume_n)
	begin
		if (!reset_n)
		begin
			reg_values=14'b11111111111111;
			//the LFSR cannot be all 0 at beginning.
			enable=1;
			rnd_ready=0;
		end
		else if (!resume_n)
		begin
			enable=1;
			rnd_ready=0;
			reg_values=reg_values;
		end
		else
		begin
			if (enable)
			begin
				reg_values[13]=reg_values[0];
				reg_values[12:5]=reg_values[13:6];
				reg_values[4]=reg_values[0] ^ reg_values[5];
				// tap 5 of the diagram from the lab manual
				reg_values[3]=reg_values[4];
				reg_values[2]=reg_values[0] ^ reg_values[3];
				// tap 3 of the diagram from the lab manual
				reg_values[1]=reg_values[2];
				reg_values[0]=reg_values[0] ^ reg_values[1];
				// tap 1 of the diagram from the lab manual
				random = reg_values + 1'd1000;
				if (random > 1'd5000)
				begin
					random = reg_values % 1'd5000;
				end
			end //end of ENABLE.
		end
	end
endmodule

module hex_to_bcd_converter(input wire clk, reset, input wire [19:0] hex_number, 
output [3:0] bcd_digit_0,bcd_digit_1,bcd_digit_2,bcd_digit_3, bcd_digit_4, 
bcd_digit_5);
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
		bcd_digit[0] <= 1'b0;
		bcd_digit[1] <= 1'b0;
		bcd_digit[2] <= 1'b0;
		bcd_digit[3] <= 1'b0;
		bcd_digit[4] <= 1'b0;
		bcd_digit[5] <= 1'b0;
		bcd_digit[6] <= 1'b0;
		//shift 20 times
		bcd_digit[0] = bcd_digit[0] << 20;
		bcd_digit[1] = bcd_digit[0] << 20;
		bcd_digit[2] = bcd_digit[0] << 20;
		bcd_digit[3] = bcd_digit[0] << 20;
		bcd_digit[4] = bcd_digit[0] << 20;
		bcd_digit[5] = bcd_digit[0] << 20;
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

module clock_divider (input Clock, Reset_n, output reg clk_ms);
	parameter factor=10; //50000; // 32’h000061a7;
	reg [31:0] countQ;
	
	always @ (posedge Clock, negedge Reset_n)
	begin
		if (!Reset_n) 
		begin
		/* fill in your code here */
		end
		
		else
		begin
			if (countQ<factor/2)
			begin
			/* fill in your code here */
			end
			
			else if (countQ<factor)
			begin
			/* fill in your code here */
			end
			
			else //countQ==factor
			begin
			/* fill in your code here */
			end
		end
	end
endmodule

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

module counter(input clk, reset_n, start_n, stop_n, output reg [WIDTH:0] ms_count);
	parameter WIDTH=20;
	
	always @(posedge clk, negedge reset_n, negedge start_n)
		if (!reset_n) //pressed button will send logic 0
			ms_count<=20'b0;
		else
			ms_count<=ms_count+1'b1;
endmodule

module lab2tut (input CLOCK_50, input [2:0] KEY, output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
output [9:0] LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8, LED9);
	wire clk_en;
	wire [19:0] ms;
	wire [3:0]  digit0, digit1, digit2, digit3, digit4, digit5;
	wire [13:0] random;
	wire randomReady;
	reg  [1:0]  state;
	reg  resumeReg = 1'b1;
	reg  resetReg  = 1'b1;
	wire resume    = resumeReg;
   wire reset     = resetReg;	
	
	random(.clk(clk_en), .reset(reset), .resume(resume), .random(random), .rnd_ready(randomReady));
	clock_divider #(.factor(50000)) (.Clock(CLOCK_50), .Reset_n(KEY[0]), .Pulse_ms(clk_en));
	counter(.clk(clk_en), .reset_n(KEY[0]), .start_n(KEY[1]), .stop_n(KEY[2]), .ms_count(ms));
	
	hex_to_bcd_converter(CLOCK_50, KEY[0], ms, digit0,digit1,digit2,digit3, digit4,digit5);
	seven_seg_decoder decoder0(digit0, HEX0);
	
	// ToDo: create a timer block - generates a signal on timeout - uses counter to count to a certain number use parameter
	always @(*) begin	
		case (state) 
			2'b00: reg_LEDs[6:2]<=5'b10000; // HEX LEDS blinking - Pregame
			2'b01: reg_LEDs[6:2]<=5'b11110; // HEX LEDS off
			2'b10: reg_LEDs[6:2]<=5'b01001; // HEX LEDS counting - game
			2'b10: reg_LEDs[6:2]<=5'b01001; // 
		endcase
	end
	/* fill in your code here */
endmodule