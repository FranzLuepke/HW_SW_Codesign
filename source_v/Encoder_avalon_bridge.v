module Encoder_avalon_bridge (clk, reset, ChannelA, ChannelB, Count, address, read, readdata, waitrequest);

input clk;
input reset;
input ChannelA, ChannelB;
output signed [31:0] Count;
// this is for the avalon interface
input [15:0] address;
input read;
output signed [31:0] readdata;
output waitrequest;

reg [2:0] ChannelA_delayed, ChannelB_delayed;
always @(posedge clk) ChannelA_delayed <= {ChannelA_delayed[1:0], ChannelA};//Seniales de los encoders retrasadas en el tiempo (1 muestreo)
always @(posedge clk) ChannelB_delayed <= {ChannelB_delayed[1:0], ChannelB};//Seniales de los encoders retrasadas en el tiempo (1 muestreo)

wire Count_enable = ChannelA_delayed[1] ^ ChannelA_delayed[2] ^ ChannelB_delayed[1] ^ ChannelB_delayed[2];//XOR entre todas las seniales
wire Count_direction = ChannelA_delayed[1] ^ ChannelB_delayed[2];//Direccion del giro (otro XOR)
//La logica de los XOR puede ser vista en la tabla de verdad de los encoders de cuadratura
//Las senales retrasadas ayudan a disminuir el ruido en la cuenta

reg signed [31:0] Count = 0;

always @(posedge clk)
begin
  if(Count_enable)//Cuenta cuando se debe, dependiendo de la direccion de giro
  begin
		if(Count_direction) 
			Count<=Count+1;
		else 
			Count<=Count-1;
  end
end

reg waitFlag;
reg [31:0] returnvalue;
assign readdata = returnvalue;
assign waitrequest = (waitFlag && read);

always @(posedge clk, posedge reset) begin: AVALON_READ_INTERFACE
	if (reset == 1) begin
		waitFlag <= 1;
	end else begin
		waitFlag <= 1;
		if(read) begin
			case(address)
				4'h0: returnvalue <= Count;
				default: returnvalue <= 32'b0;
			endcase
			if(waitFlag==1) begin // next clock cycle the returnvalue should be ready
				waitFlag <= 0;
			end
		end
	end
end

endmodule
