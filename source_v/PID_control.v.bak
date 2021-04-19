//Modulo de control PID para los RPM de traccion
//Solo toma en cuenta numeros enteros y recibe un Setpoint de la base de control
//Las salidas estan basadas en el shield que tiene Robocol
//(Habian mas hasta que Miguelito los quemo)
module PID_control(Prescaler_clk, SetPoint, RPM_Medidas, DIR_A, DIR_B, COMANDO_PWM);


input Prescaler_clk;//Clock que controla la velocidad del control
input signed [15:0] SetPoint;//Set point en RPM
input signed [15:0] RPM_Medidas;//RPM medidas por el encoder

output [7:0] COMANDO_PWM;//PWM en 8 bits, entre 0 y 249
reg [7:0] COMANDO_PWM = 0;

output DIR_A;//Salida 1 de direccion al motor
reg DIR_A = 0;

output DIR_B;//Salida 2 de direccion al motor
reg DIR_B = 0;

reg signed [35:0] Error_Integrativo = 0;//Variable para integracion

parameter signed K_P = 5;// Kp*100 (debe calibrarse)
parameter signed K_I = 1;// Ki*100 (debe calibrarse)


always @(negedge Prescaler_clk)
begin
	
	if (  ( K_P*(SetPoint-RPM_Medidas) + K_I*Error_Integrativo )/100  >= 249) //Caso de saturacion del controlador por arriba
		COMANDO_PWM <= 249;
	else
		if (  ( K_P*(SetPoint-RPM_Medidas) + K_I*Error_Integrativo )/100   <= -249) //Caso de saturacion del controlador por abajo
			COMANDO_PWM <= 249;
		else
			if (SetPoint==0) //Caso en el que se desea alcanzar 0 en velocidad
				COMANDO_PWM <= 0;
			else
				if(   ( K_P*(SetPoint-RPM_Medidas) + K_I*Error_Integrativo )/100 >= 0) //Caso sin saturacion, error positivo
					COMANDO_PWM <= ( K_P*(SetPoint-RPM_Medidas) + K_I*Error_Integrativo )/100;
				else
					COMANDO_PWM <= -( K_P*(SetPoint-RPM_Medidas) + K_I*Error_Integrativo )/100;//Caso sin saturacion, error negativo
			
			
	if( K_P*(SetPoint-RPM_Medidas) + K_I*Error_Integrativo > 0 & SetPoint!=0 )//Motor hacia adelante si el error es mayor a 0
		begin
			DIR_A<=1;
			DIR_B<=0;
		end
	else
		if(K_P*(SetPoint-RPM_Medidas) + K_I*Error_Integrativo < 0 & SetPoint!=0) //Motor hacia atras si el error es menor a 0
			begin
				DIR_A<=0;
				DIR_B<=1;
			end
		else//Freno en las llantas si el setpoint es 0
			begin
				DIR_A<=1;
				DIR_B<=1;
			end
	
	if(SetPoint!=0)//Acumulador del error integrativo, se reinicia cuando el setpoint pasa por 0 RPM 
		Error_Integrativo <= Error_Integrativo + (SetPoint-RPM_Medidas);
	else
		Error_Integrativo <= 0;
  
end



endmodule


