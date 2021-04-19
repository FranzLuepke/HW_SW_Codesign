module contador(reset, clock, ciclos, flag);
//INPUTS AND OUTPUTS
input 			reset;			// Reset
input 			clock;			// Clock
input [27:0]	ciclos;			// Number of cycles to count
output 			flag;				// Flag to indicate the counts ended
// REGS
reg [27:0]		conteo = 0;		// Actual counts
reg				out_reg = 0;	// Output
// ASSIGNS
assign flag = out_reg;			// Output flag assignation

// Sequential logic
always@(posedge clock)
begin
	if(reset==1'b1 || conteo==ciclos) // Resets count when the number of cycles is reached or if it doesn't have to count
		begin
			conteo <= 28'd0;
		end
	else // Else, counts
		conteo <= conteo + 28'd1;
end
always@(posedge clock)
begin
	if(conteo==ciclos)
		out_reg = 1;
	else
		out_reg = 0;
end

endmodule
