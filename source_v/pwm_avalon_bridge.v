// pwm_avalon_bridge node
// you can read out the registers via avalon bus in the following way:
// #define IORD(base,reg) (*(((volatile uint32_t*)base)+reg))
// #define IOWR(base,reg,data) (*(((volatile uint32_t*)base)+reg)=data)
// where reg corresponds to the address of the avalon slave

`timescale 1ns/10ps

module pwm_avalon_bridge (
	input clk,
	input reset,
	// this is for the avalon interface
	input [15:0] address,
	input write,
	input signed [31:0] writedata,
	// these are the pwm ports
	output [NUMBER_OF_MOTORS-1:0] PWM
);

parameter NUMBER_OF_MOTORS = 6;
parameter CLOCK_SPEED_HZ = 50_000_000;
parameter PWM_FREQ = 20_000;
parameter PWM_PAUSE_FREQ = 50;
parameter PWM_RESOLUTION = 8;
parameter PWM_PHASES = 1;

reg [31:0] i;
reg [31:0] duty[NUMBER_OF_MOTORS-1:0];
reg [NUMBER_OF_MOTORS-1:0] ena;
	
always @(posedge clk, posedge reset) begin: PWM_CONTROL_LOGIC
	if (reset == 1) begin 
		for(i=0; i<NUMBER_OF_MOTORS; i = i+1) begin : reset_pwm_controller
			duty[i] <= 0;
			ena[i] <= 0;
		end
	end else begin
		if(write) begin
			if(address[7:0]<NUMBER_OF_MOTORS) begin
				duty[address[7:0]] <= writedata; 
				ena[address[7:0]] <= 1;
			end
		end
		for(i=0; i<NUMBER_OF_MOTORS; i = i+1) begin : reset_pwm_controller_after_enable
			if(ena[i]==1) begin
				ena[i] <= 0;
			end
		end
	end 
end

genvar j;
generate 
	for(j=0; j<NUMBER_OF_MOTORS; j = j+1) begin : instantiate_pwm_controllers
		PWM_Generator motor(
			.clock(clk),
			.reset(~reset),
			.PWM_in(duty[j][7:0]),
			.PWM_out(PWM[j])
		);
	end
endgenerate 

endmodule
