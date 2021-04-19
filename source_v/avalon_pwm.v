module avalon_pwm (
	input clk,								// Clock input
	input reset,							// Reset input
	input address,							// Avalon interface address
	input write,							// Avalon interface write bit
	input signed [31:0] writedata,	// Avalon interface writedata bus
	output [7:0] duty				// Duty cycle output to PWM module
);

reg duty_cycle = 0;

assign duty = duty_cycle;	// Asignacion de la salida
	
always @(posedge clk, posedge reset)
begin: PWM_CONTROL_LOGIC
	if(reset == 1)
	begin: reset_pwm_controller
		duty_cycle <= 0;
	end
	else
	begin
		if(write)
		begin
			case (address)
				1'b0    : duty_cycle <= writedata[7:0];
				default : duty_cycle <= duty_cycle;
			endcase
		end
	end
end

endmodule
