

module SH_REG (

//////////// OUTPUTS //////////

	bus_tx,
	SH_Done,
	
//////////// INPUTS //////////

	CLOCK,//Reloj
	Mega_MSG,
	SH_enable,
);


//=======================================================
//  PORT declarations
//=======================================================



output wire [7:0] bus_tx;
output reg SH_Done = 0;
	
input	CLOCK;
input	[911:0] Mega_MSG;
input SH_enable;
	
	
	
//=======================================================
//  REG/WIRE declarations
//=======================================================


reg [7:0] bitpos_reg = 8'd0;
reg [911:0] msg_actual;


parameter STATE_0 = 3'd0;
parameter STATE_1 = 3'd1;
parameter STATE_2 = 3'd2;
parameter STATE_AUX = 3'd3;

reg [2:0] state = STATE_0;
reg [2:0] state_signal = STATE_0;

	
	
//=======================================================
//  Structural coding
//=======================================================



// SECUENCIAL
always @(negedge CLOCK) 
begin
	case (state)
		STATE_AUX: msg_actual <= Mega_MSG;
		STATE_0: msg_actual <= msg_actual;
		STATE_1: begin
						msg_actual <= msg_actual>>8;
						bitpos_reg <= bitpos_reg + 1;
					end
		STATE_2: bitpos_reg <= 0;
		
		default: begin
						msg_actual <= msg_actual;
						bitpos_reg <= bitpos_reg;
					end
	endcase
	state <= state_signal;
end



// SALIDAS
always @(*) begin
	
	case (state)
		
		STATE_AUX: SH_Done = 1'b0;
		STATE_0: SH_Done = 1'b0;
		STATE_1: SH_Done = 1'b0;
		STATE_2: SH_Done = 1'b1;
	
	endcase
	
end


// ESTADO SIGUIENTE

always @(*) begin
	
	case (state)
	
	
		STATE_AUX: if (SH_enable)
						state_signal = STATE_1;
					else
						state_signal = STATE_AUX;
			
	
		STATE_0: if (SH_enable)
						state_signal = STATE_1;
					else
						state_signal = STATE_0;
						
						
						
						
		STATE_1: if (bitpos_reg >= 114)
						state_signal = STATE_2;
					else
						state_signal = STATE_0;
						
						
						
		STATE_2: state_signal = STATE_AUX;
		
		
		
		
		default: state_signal = STATE_AUX;
	
	endcase
	
end




assign bus_tx =  msg_actual[7:0];

endmodule
