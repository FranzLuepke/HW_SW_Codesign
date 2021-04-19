//ESTE MODULO NO ESTA COMENTADO YA QUE ES CASI IGUAL AL DETECTOR_MENSAJES.V//
//ESTE MODULO NO ESTA COMENTADO YA QUE ES CASI IGUAL AL DETECTOR_MENSAJES.V//
//ESTE MODULO NO ESTA COMENTADO YA QUE ES CASI IGUAL AL DETECTOR_MENSAJES.V//
module Detector_Mensajes_01(rdy, rdy_clr, dout, CLOCK_50, SALIDA_AL_MOTOR, SALIDA_DIRECCION, LETRA_DETECTAR);


//Entradas y salidas

input rdy;
input [7:0] dout;
input CLOCK_50;
input [7:0] LETRA_DETECTAR;

output rdy_clr;
reg salida_rdy_clr;
assign rdy_clr=salida_rdy_clr;

//PWM de salida

output [7:0] SALIDA_AL_MOTOR;
reg [7:0] PWM_SALIDA = 0;
assign SALIDA_AL_MOTOR=PWM_SALIDA;

//DIRECCION SALIDA

output signed [1:0] SALIDA_DIRECCION;
reg signed [1:0] SENTIDO_RX = 0;
assign SALIDA_DIRECCION=SENTIDO_RX;

//Dato temporal recibido

reg [7:0] TEMPORAL = 0;

//Constantes de estado

parameter ESPERA=2'd0;
parameter LISTO=2'd1;
parameter ESPERANDO_BYTE=2'd2;
parameter LEER_BYTE=2'd3;




parameter CARACTER_TERMINACION = 8'd35; //#
parameter CARACTER_TERMINACION_ATRAS = 8'd33; //!

//Registros de estado

reg [1:0] estado_actual=ESPERA;//Estado inicial
reg [1:0] estado_futuro;//Registro del estado futuro


//Logica secuencial


always@(posedge CLOCK_50)
begin
	estado_actual<=estado_futuro;//Sin reset pasa al estado siguiente
end

always@(posedge CLOCK_50)
begin
	if( (estado_actual == LEER_BYTE) && (dout != CARACTER_TERMINACION) && (dout != CARACTER_TERMINACION_ATRAS ))
		TEMPORAL <= (TEMPORAL*10) + dout - 48;
	else if ( (estado_actual == LEER_BYTE) && (dout == CARACTER_TERMINACION ) )
		begin
			PWM_SALIDA <= TEMPORAL;
			SENTIDO_RX <= 1;
			TEMPORAL <= 0;
		end
	else if ( (estado_actual == LEER_BYTE) && (dout == CARACTER_TERMINACION_ATRAS ) )
		begin
			PWM_SALIDA <= TEMPORAL;
			SENTIDO_RX <= 0;
			TEMPORAL <= 0;
		end
end

//Fin logica secuencial





//Logica combinacional de estados
always@(*)
begin
case(estado_actual)

ESPERA:begin
			if(dout==LETRA_DETECTAR)
				estado_futuro=LISTO;
			else
				estado_futuro=ESPERA;
			end
LISTO:begin
			estado_futuro=ESPERANDO_BYTE;
		end

ESPERANDO_BYTE:begin
			if(rdy)
				estado_futuro=LEER_BYTE;
			else
				estado_futuro=ESPERANDO_BYTE;
			end
			
LEER_BYTE:begin
			if(dout != CARACTER_TERMINACION  && dout != CARACTER_TERMINACION_ATRAS )
				estado_futuro=ESPERANDO_BYTE;
			else
				estado_futuro=ESPERA;
	
			end

			
			


default:estado_futuro=ESPERA;//Caso defecto
endcase
end







//Logica combinacional de salidas
always@(*)
begin
case(estado_actual)

ESPERA:begin
		salida_rdy_clr=0;
		end
		
LISTO:begin
		salida_rdy_clr=1;
		end

ESPERANDO_BYTE:begin
		salida_rdy_clr=0;
		end
		
LEER_BYTE:begin
		salida_rdy_clr=1;
		end

		
endcase
end





endmodule
