//  A testbench for 32-bit_ALU_with_Zero
`timescale 10ns/100ps
//Set 80 ns
module ALU_with_Zero_tb();
	
	//Declare test variables
	parameter N = 32;
	reg [(N-1):0] a, b;
	reg [2:0] sel;
	reg [2:0] patterns[0:6];
	wire cout, Z_flag;
	wire [(N-1):0] y; 
	integer i;

	//Instantiate the design with testbench variables
	ALU_with_Zero fucnt (.a (a), 
						.b (b), 
						.sel (sel), 
						 .cout (cout),
						 .y (y),
						 .Z_flag (Z_flag));

	//ALU_with_Zero Test
	initial begin
		patterns[0] = 3'b000;
		patterns[1] = 3'b001;
		patterns[2] = 3'b010;
		patterns[3] = 3'b100;
		patterns[4] = 3'b101;
		patterns[5] = 3'b011;
		patterns[6] = 3'b111;

		for(i=0; i<7; i=i+1) begin
			 	a <= 6'b011001;
				b <= 6'b100000;
				sel[2:0] <= patterns[i];
				#1
				case(sel)
				3'b000:
				begin
					$display ("AND logic test initiated...");
					if (y !== 32'b0) begin
						$display ("Error: Incorrect AND logic! -> %b", y);
						$stop;
						end
					else
						$display ("AND logic completed: No error found.");
					$display("Output: Z_Flag -> %b", Z_flag);
				end
				3'b001:
				begin
					$display ("OR logic test initiated...");
					if (y !== (a ^ b ^ 1'b0)) begin
						$display ("Error: Incorrect OR logic! -> %b", y);
						$stop;
					end
					else
						$display ("OR logic completed: No error found.");
					$display("Output: Z_Flag -> %b", Z_flag);
				end
				3'b010:
				begin
					$display ("Addition test initiated...");
					if (y !== 6'b111001) begin
						$display ("Error: Incorrect addition! -> %b", y);
						$stop;
					end
					else if (cout !== 1'b0) begin
						$display ("Overflow detected!!!");
						$stop;
					end
					else
						$display ("Addition completed: No error found.");
					$display("Output: Z_Flag -> %b", Z_flag);
				end
				3'b100: // A & ~B
				begin
					$display ("A & not B test initiated...");
					if (y !== a) begin
						$display ("Error: Incorrect output! -> %b", y);
						$stop;
					end
					else
						$display ("A & not B completed: No error found.");
					$display("Output: Z_Flag -> %b", Z_flag);
				end
				3'b101: // A | ~B
				begin
					$display ("A | not B test initiated...");
					if (y !== ~b) begin
						$display ("Error: Incorrect operation! -> %b", y);
						$stop;
					end
					else
						$display ("A | not B completed: No error found.");
					$display("Output: Z_Flag -> %b", Z_flag);
				end
				3'b011:
				begin
					$display ("Subtraction test initiated...");
					if (y !== 32'b11111111111111111111111111111001) begin
						$display ("Incorrect subtraction! -> %b", y);
						$stop;
					end
					else if (cout !== 1'b1) begin
						$display ("Sign bit not detected!!!");
						$stop;
					end
					else
						$display ("Subtraction completed: No error found!!!");
					$display("Output: Z_Flag -> %b", Z_flag);
				end
				3'b111: // Set less than
				begin
					$display ("SetLessThan test initiated...");
					if (y == 1'b1)
						$display ("SetLessThan completed: No error found!!!");
					else begin
						$display ("SetLessThan error: Incorrect Carry-out -> %b", cout);
						$display ("SetLessThan error: Incorrect Output -> %b", y);
					end
					$display("Output: Z_Flag -> %b", Z_flag);
				end
				default: 
					$display ("Selection is unknown or invalid!!!");
			endcase
		end
	end

endmodule