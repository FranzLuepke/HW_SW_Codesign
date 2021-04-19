//Modulo que cuenta flancos en un encoder de cuadratura
//El giro hacia un lado del encoder suma a la variable Count, hacia el otro lado le resta
module Encoder(clk, ChannelA, ChannelB, Count);

input clk, ChannelA, ChannelB;
output signed [35:0] Count;

reg [2:0] ChannelA_delayed, ChannelB_delayed;
always @(posedge clk) ChannelA_delayed <= {ChannelA_delayed[1:0], ChannelA};//Seniales de los encoders retrasadas en el tiempo (1 muestreo)
always @(posedge clk) ChannelB_delayed <= {ChannelB_delayed[1:0], ChannelB};//Seniales de los encoders retrasadas en el tiempo (1 muestreo)

wire Count_enable = ChannelA_delayed[1] ^ ChannelA_delayed[2] ^ ChannelB_delayed[1] ^ ChannelB_delayed[2];//XOR entre todas las seniales
wire Count_direction = ChannelA_delayed[1] ^ ChannelB_delayed[2];//Direccion del giro (otro XOR)
//La logica de los XOR puede ser vista en la tabla de verdad de los encoders de cuadratura
//Las senales retrasadas ayudan a disminuir el ruido en la cuenta

reg signed [35:0] Count = 0;


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

endmodule
