// Clock prescaller
module Prescaller(reset, clock, outCLK, cuentas);

// INPUTS AND OUTPUTS
input				reset;				// Reset
input				clock;				// Clock
input [27:0]	cuentas;				// Edges to count
output 			outCLK;				// Output clock
// REGS
reg 				salidaActual = 0;	// Output
// WIRES
wire 				flag;
// ASSIGNS
assign outCLK = salidaActual;		// Output assignation

// EXTERNAL MODULES
contador pos_edge_counter(reset, clock, cuentas, flag); // Generic edges counter

// Sequential logic - STATE MACHINE
always@(posedge clock)
begin
	if(flag) // Oscillation every counter edge
		salidaActual<=!salidaActual;
end

endmodule
