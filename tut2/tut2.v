module clock_divider (input Clock, Reset_n, output reg clk_ms);
	parameter factor=20; //50000; // 32’h000061a7;
	reg [31:0] countQ;
	always @ (posedge Clock, negedge Reset_n)
	begin
		if (!Reset_n) 
		begin
			countQ <= 0;
		end
		else
		begin  
			countQ <= countQ + 1'b1;
			if (countQ<factor/2)
			begin
				clk_ms <= 1;
			end
			else if (countQ<=factor)
			begin
				 clk_ms <= 0;
			end
			else //countQ==factor
			begin
				 countQ <= 0;
				 clk_ms <= 1;
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

module hex_to_bcd_converter(input wire clk, reset, input wire [19:0] hex_number, output [3:0] bcd_digit_0,bcd_digit_1,bcd_digit_2,bcd_digit_3, bcd_digit_4,bcd_digit_5);
	integer i, k;
	wire [19:0] hex_number1; // the last 20 bits of input hex_number

	reg [3:0] bcd_digit [5:0]; //simplifies program
	assign hex_number1=hex_number[19:0];
	assign bcd_digit_0 = bcd_digit[0];
	assign bcd_digit_1 = bcd_digit[1];
	assign bcd_digit_2 = bcd_digit[2];
	assign bcd_digit_3 = bcd_digit[3];
	assign bcd_digit_4 = bcd_digit[4];
	assign bcd_digit_5 = bcd_digit[5];
	always @ (*)
	begin
		//set all 6 digits to 0
		bcd_digit[0] = 4'b0;
		bcd_digit[1] = 4'b0;
		bcd_digit[2] = 4'b0;
		bcd_digit[3] = 4'b0;
		bcd_digit[4] = 4'b0;
		bcd_digit[5] = 4'b0;
		
		//shift 20 times
		for ( i = 19; i >= 0; i = i - 1 )
		begin
			for ( k = 5; k >= 0; k = k - 1)
			begin
				if ( bcd_digit[k] >= 5)
					bcd_digit[k] = bcd_digit[k] + 3;
			end
			
			//shift one bit of BIN/HEX left
			//for the first 5 tetrads
			for ( k = 5; k >= 1; k = k - 1 )
			begin
				bcd_digit[k]=bcd_digit[k] << 1;
				bcd_digit[k][0]=bcd_digit[k-1][3];
			end
		//shift one bit of BIN/HEX left, for the last tetrad
		bcd_digit[0] = bcd_digit[0] << 1;
		bcd_digit[0][0] = hex_number[i];
		end //end for loop
	end //end of always.
	
endmodule

module hex_bcd ( output [3:0] a );
	assign a = 4'b1001;
endmodule

module counter(input clk, reset_n, start_n, stop_n, output reg [WIDTH-1:0] ms_count);
	parameter WIDTH=20;
	reg state = 0; // 0 = stopped, 1 = running
	always @ ( negedge start_n, negedge stop_n )
	begin 
		if ( start_n == 0)
		begin	
			state <= 1;
		end
		
		else if ( stop_n == 0)
		begin
			state <= 0;
		end
		
	end
	always @ ( negedge reset_n, posedge clk )
	begin
	    // Buttons are pulled up
		if ( reset_n == 0 ) // If reset is pressed// pressed button will send logic 0
		begin 
			ms_count <= 20'b0; // Set counter to 0
		end
		else if ( state == 1 )
		begin
			ms_count <= ms_count + 1'b1; // Increment counter
		end
	end
endmodule

module tut2 ( input CLOCK_50, input [2:0] KEY, output [6:0] HEX0, HEX1, HEX2,HEX3, HEX4, HEX5 );
	

   wire [19:0] ms;
	wire clk_en;
	wire [3:0] digit0,digit1,digit2,digit3, digit4,digit5;
   clock_divider #(.factor(4)) (.Clock(CLOCK_50), .Reset_n(KEY[0]), .clk_ms(clk_en));

	counter(.clk(clk_en), .reset_n(KEY[0]), .start_n(KEY[1]), .stop_n(KEY[2]), .ms_count(ms));

	hex_to_bcd_converter(CLOCK_50, KEY[0], ms, digit0,digit1,digit2,digit3, digit4,digit5);

	seven_seg_decoder decoder0(digit0, HEX0);
	seven_seg_decoder decoder1(digit1, HEX1);
	seven_seg_decoder decoder2(digit2, HEX2);
	seven_seg_decoder decoder3(digit3, HEX3);
	seven_seg_decoder decoder4(digit4, HEX4);
	seven_seg_decoder decoder5(digit5, HEX5);

endmodule