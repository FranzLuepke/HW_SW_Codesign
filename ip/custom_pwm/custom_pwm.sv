module custom_pwm
(
    input  logic        clk,                // clock.clk
    input  logic        reset,              // reset.reset
    // Memory mapped read/write slave interface
    input  logic        avs_s0_address,     // avs_s0.address
    input  logic        avs_s0_read,        // avs_s0.read
    input  logic        avs_s0_write,       // avs_s0.write
    output logic [31:0] avs_s0_readdata,    // avs_s0.readdata
    input  logic [31:0] avs_s0_writedata,   // avs_s0.writedata
    // custom_pwm outputs
    output logic [7:0]  PWM_out
);
	// Read operations performed on the Avalon-MM Slave interface
	always_comb begin
		 if (avs_s0_read) begin
			  case (avs_s0_address)
					1'b0    : avs_s0_readdata = {24'b0, PWM_out};
					default : avs_s0_readdata = 'x;
			  endcase
		 end else begin
			  avs_s0_readdata = 'x;
		 end
	end
	// Write operations performed on the Avalon-MM Slave interface
	always_ff @ (posedge clk) begin
		 if (reset) begin
			  PWM_out <= '0;
		 end else if (avs_s0_write) begin
			  case (avs_s0_address)
					1'b0    : PWM_out <= avs_s0_writedata;
					default : PWM_out <= PWM_out;
			  endcase
		 end
	end
endmodule // custom_pwm