module creacion_mensaje (
	input clk,
	input	[15:0] bcd,
	input signo, 
	input start,
	input [7:0] caracter_terminacion,
	output [47:0] mensaje_completo,
	output done
	);
	
	wire [15:0] bin_mensaje;
	
	//Modulos
Binary_to_BCD Bin_BCD(clk, bcd, start, bin_mensaje, done);
Composicion_Mensaje Comp_Mensaje(bin_mensaje, signo, caracter_terminacion, mensaje_completo);
	
endmodule
