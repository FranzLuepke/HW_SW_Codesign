module avalon_led (
	input clk,
	input reset,
	// this is for the avalon interface
	input [15:0] address,
	input write,
	input signed [31:0] writedata,
	// these are the pwm ports
	output reg [7:0] leds
);
	
always @(posedge clk, posedge reset)
begin: LEDS_CONTROL_LOGIC
	if (reset == 1)
	begin : reset_pwm_controller
		leds <= 0;
	end
	else
	begin
		if(write)
		begin
			case (address)
				1'b0    : leds <= writedata[7:0];
				default : leds <= leds;
			endcase
		end
	end
end

endmodule
