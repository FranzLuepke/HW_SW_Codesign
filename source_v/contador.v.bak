module contador(reset, clock, ciclos, flag);
//INPUTS AND OUTPUTS
input reset;//Reset
input clock;//Clock
input [27:0] ciclos;//Numero de ciclos a contar
output flag;//Indica si termino el conteo
//REGS
reg [27:0] conteo = 0;//Conteo actual
reg salida=0;//Salida
assign flag=salida;//Asignacion de la salida
//Logica secuencial
always@(posedge clock)
begin
   //Reinicia conteo si llego al numero de ciclos o si no debe contar
	if(reset==1'b1||conteo==ciclos)
	begin
		conteo<=28'd0;
	end
	else//De lo contrario, cuenta
		conteo<=conteo+28'd1;
end

always@(posedge clock)
begin
	if(conteo==ciclos)
		salida=1;
	else
		salida=0;
end


endmodule
