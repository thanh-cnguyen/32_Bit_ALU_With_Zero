module ALU_with_Zero ( a, b, sel, cout, y, Z_flag);

	parameter N = 32;
	input [(N-1):0] a, b;
	input [2:0] sel;
	output reg cout;
	output reg [(N-1):0] y;
	output reg Z_flag;
	wire add_in = 1'b0;
	wire sub_in = 1'b1;
	reg car;

	always @(*)
	begin
		case(sel)
			3'b000: // And logic
				y <= (a & b);
			3'b001: // Or logic
				y <= (a | b);
			3'b010: // Addition
				begin
					y <= a ^ b ^ add_in;
					cout <= (a & b) | (add_in & (a ^ b));
				end
			3'b100: // A & ~B
				y <= a & ~b;
			3'b101: // A | ~B
				y <= a | ~b;
			3'b011: // Subtraction
				begin
					{car, y} <= a + ((b ^ {N{sub_in}}) + sub_in);
					cout <= car ^ y[(N-1)];
				end
			3'b111: // Set less than
				begin
					cout <= (a & b) | (b & sub_in) | (a & sub_in);
					if (cout == 1'b1)
						y <= 1'b1;
					else
						y <= 1'b0;
				end
			default: 
				y <= a & b;
		endcase

		// Check if final output is empty
		begin
			if (y == 32'b0)
				Z_flag <= 1'b1;
			else
				Z_flag <= 1'b0;
		end
	end
	
endmodule
