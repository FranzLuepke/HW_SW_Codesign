//Modulo que recibe las ordenes de la base
//Detecta una letra especifica que entra por parametro, luego guarda los numeros consiguientes
//hasta que aparezca un caracter de terminacion
//Este caracter determina la direccion del movimiento
module Detector_Mensajes(rdy, rdy_clr, dout, CLOCK_50, SALIDA_AL_MOTOR, SALIDA_DIRECCION, LETRA_DETECTAR);


//Entradas y salidas

input rdy;//Byte listo para procesar
input [7:0] dout;//Byte de entrada
input CLOCK_50;
input [7:0] LETRA_DETECTAR;//Letra por parametro que se debe detectar para empezar a guardar datos

output rdy_clr;//Salida para limpiar la bandera de listo
reg salida_rdy_clr;
assign rdy_clr=salida_rdy_clr;

//PWM de salida

output [7:0] SALIDA_AL_MOTOR;//Salida de PWM para el generador de la senal
reg [7:0] PWM_SALIDA = 0;
assign SALIDA_AL_MOTOR=PWM_SALIDA;

//DIRECCION SALIDA

output signed [1:0] SALIDA_DIRECCION;//Direccion de salida dependiendo del caracter de terminacion
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

//Maquina que guarda el byte y detecta cuando terminar
always@(posedge CLOCK_50)
begin
	if( (estado_actual == LEER_BYTE) && (dout != CARACTER_TERMINACION) && (dout != CARACTER_TERMINACION_ATRAS ))//Caso en el que no se ha terminado
		TEMPORAL <= (TEMPORAL*10) + dout - 48;//Se concatena el numero, teniendo en cuenta la conversion ASCII y que los numeros se reciben en BCD
	else if ( (estado_actual == LEER_BYTE) && (dout == CARACTER_TERMINACION ) )//Caracter de terminacion hacia adelante recibido
		begin
			PWM_SALIDA <= TEMPORAL;//Se asigna la salida
			SENTIDO_RX <= 1;//Se asigna el sentido
			TEMPORAL <= 0;//Se limpia la variable temporal
		end
	else if ( (estado_actual == LEER_BYTE) && (dout == CARACTER_TERMINACION_ATRAS ) )//Caracter de terminacion hacia atras recibido
		begin
			PWM_SALIDA <= TEMPORAL;//Se asigna la salida
			SENTIDO_RX <= -1;//Se asigna el sentido
			TEMPORAL <= 0;//Se limpia la variable temporal
		end
end

//Fin logica secuencial





//Logica combinacional de estados
always@(*)
begin
case(estado_actual)

ESPERA:begin
			if(dout==LETRA_DETECTAR)//Si se detecta la letra, se empiezan a guardar bytes
				estado_futuro=LISTO;
			else
				estado_futuro=ESPERA;
			end
LISTO:begin
			estado_futuro=ESPERANDO_BYTE;
		end

ESPERANDO_BYTE:begin//Se lee cada byte (uno a uno)
			if(rdy)
				estado_futuro=LEER_BYTE;
			else
				estado_futuro=ESPERANDO_BYTE;
			end
			
LEER_BYTE:begin
			if(dout != CARACTER_TERMINACION  && dout != CARACTER_TERMINACION_ATRAS )//Detecta cuando se llego al caracter de terminacion
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
		salida_rdy_clr=0;//Salidas para limpiar la bandera de recepcion
		end
		
LISTO:begin
		salida_rdy_clr=1;//Salidas para limpiar la bandera de recepcion
		end

ESPERANDO_BYTE:begin
		salida_rdy_clr=0;//Salidas para limpiar la bandera de recepcion
		end
		
LEER_BYTE:begin
		salida_rdy_clr=1;//Salidas para limpiar la bandera de recepcion
		end

		
endcase
end





endmodule
