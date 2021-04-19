//Este modulo deriva la senal de los encoders para entrar la velocidad de los motores
//La salida esta en RPM y la entrada son las cuentas actuales del encoder
module RPM(Prescaler_clk, cuentas, RPM_Medidos);


input Prescaler_clk; //Clock escalado a 5ms
input signed [35:0] cuentas; //Cuentas actuales del encoder
output signed [15:0] RPM_Medidos; //Velocidad en RPM

reg signed [15:0] RPM_Medidos = 0; //Velocidad en RPM

reg signed [35:0] cuentas_anteriores = 0; //Variable temporal para derivacion

//LOGICA SECUENCIAL
always @(posedge Prescaler_clk)
begin
  RPM_Medidos <= ( (cuentas - cuentas_anteriores)*3125 ) / 10000; //Realiza la derivada. Las constantes se calculan a partir de las CPR del encoder, la caja de reduccion y los 5ms del clock
  cuentas_anteriores <= cuentas; //Asignacion de la variable temporal para la derivada
end




endmodule
