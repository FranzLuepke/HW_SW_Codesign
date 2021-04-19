module moduloEnableMotores(clock, motor, state, EN1, EN2, EN3, EN4, EN5, EN6);

input clock;
input [7:0] motor;
input [1:0] state;
output reg EN1, EN2, EN3, EN4, EN5, EN6 = 1'b0;

always @(posedge clock) begin

	case(motor)

		8'd0 : EN1 <= state[0];
		8'd1 : EN2 <= state[0];
		8'd2 : EN3 <= state[0];
		8'd3 : EN4 <= state[0];
		8'd4 : EN5 <= state[0];
		8'd5 : EN6 <= state[0];

		default : begin

			EN1 <= EN1;
			EN2 <= EN2;
			EN3 <= EN3;
			EN4 <= EN4;
			EN5 <= EN5;
			EN6 <= EN6;
			
		end

	endcase

end






endmodule
