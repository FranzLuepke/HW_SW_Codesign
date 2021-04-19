//Prescaller de clock
module Prescaller(reset, clock, outCLK, cuentas);

//INPUTS AND OUTPUTS
input reset;//Reset
input clock;//Clock
input [27:0] cuentas;//Flancos a contar
output outCLK;//Clock de salida

//REGS
reg salidaActual=0;//Salida
assign outCLK=salidaActual;//Asignacion de la salida

//WIRES
wire flag;

//MODULOS

contador contadorSubida(reset, clock, cuentas, flag);//Contador de flancos generico


//Logica secuencial MAQUINA DE ESTADOS
always@(posedge clock)
begin
	if(flag)//Se oscila la salida cada flanco del contador
		salidaActual<=!salidaActual;
end


endmodule
