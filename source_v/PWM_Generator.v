// Generates PWM signal from an 8 bits number, betwenn 0 and 249.
module PWM_Generator(clock, reset, PWM_in, PWM_out);
// INPUTS AND OUTPUTS
input 		clock;	// Clock
input 		reset;	// Reset
input [7:0]	PWM_in;	// PWM requested
output 		PWM_out;	// PWM out signal
// REGS
reg			salidaActual	= 0;					// Salida
assign		PWM_out			= salidaActual;	// Asignacion de la salida
// WIRES
wire 			flagSubida;
wire 			flagBajada;
// MODULOS
contador contadorSubida(reset, clock, 2500, flagSubida); // Indica cuando subir la senal de salida
contador contadorBajada(flagSubida, clock, 10*PWM_in, flagBajada); // Indica cuando bajar la senal de salida
// La bajada depende de la entrada, por lo que modula el ancho de pulso
// Logica secuencial MAQUINA DE ESTADOS
always@(posedge clock) // Maquina de estados que traduce los flags en la senal
	begin
		if(PWM_in==250)
			salidaActual <= 1;
		else
			begin
				if(flagSubida)
					salidaActual <= 1;
				else
					begin
						if(flagBajada)
							salidaActual <= 0;
					end
			end
	end
endmodule
