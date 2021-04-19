//Genera la senal de PWM a partir de un numero de 8 bits, entre 0 y 249
module moduloPWM(reset, clock, inPWM, outPWM);

//INPUTS AND OUTPUTS
input reset;//Reset
input clock;//Clock
input [7:0] inPWM;//PWM solicitado
output outPWM;//Senal

//REGS
reg salidaActual=0;//Salida
assign outPWM=salidaActual;//Asignacion de la salida

//WIRES
wire flagSubida;
wire flagBajada;


//MODULOS

contador contadorSubida(reset, clock, 2500, flagSubida); //Indica cuando subir la senal de salida
contador contadorBajada(flagSubida, clock, 10*inPWM, flagBajada);//Indica cuando bajar la senal de salida
//La bajada depende de la entrada, por lo que modula el ancho de pulso

//Logica secuencial MAQUINA DE ESTADOS
always@(posedge clock)//Maquina de estados que traduce los flags en la senal
begin
	if(inPWM==250)
		salidaActual<=1;
	else
	begin
		if(flagSubida)
			salidaActual<=1;
		else
		begin
			if(flagBajada)
				salidaActual<=0;
		end
	end
end


endmodule
