module CreadorMensajeCompleto(
	input Clock,
	
	input [15:0] corriente1,
	input [15:0] corriente2,
	input [15:0] corriente3,
	input [15:0] corriente4,
	input [15:0] corriente5,
	input [15:0] corriente6,
	
	input [15:0] angulo1,
	input [15:0] angulo2,
	input [15:0] angulo3,
	input [15:0] angulo4,
	input [15:0] angulo5,
	input [15:0] angulo6,
	input [15:0] angulo7,
	
	input [15:0] rpm1,
	input [15:0] rpm2,
	input [15:0] rpm3,
	input [15:0] rpm4,
	input [15:0] rpm5,
	input [15:0] rpm6,
	
	input startBCD,
	
	output wire doneBCD,
	output wire [911:0] mensaje);
	
	
	wire done_corriente1;
	wire done_corriente2;
	wire done_corriente3;
	wire done_corriente4;
	wire done_corriente5;
	wire done_corriente6;
	
	wire done_angulo1;
	wire done_angulo2;
	wire done_angulo3;
	wire done_angulo4;
	wire done_angulo5;
	wire done_angulo6;
	wire done_angulo7;
	
	wire done_rpm1;
	wire done_rpm2;
	wire done_rpm3;
	wire done_rpm4;
	wire done_rpm5;
	wire done_rpm6;
	
	wire signo_rpm1;
	wire signo_rpm2;
	wire signo_rpm3;
	wire signo_rpm4;
	wire signo_rpm5;
	wire signo_rpm6;
	
	wire [15:0] A2_Bin_rpm1;
	wire [15:0] A2_Bin_rpm2;
	wire [15:0] A2_Bin_rpm3;
	wire [15:0] A2_Bin_rpm4;
	wire [15:0] A2_Bin_rpm5;
	wire [15:0] A2_Bin_rpm6;
	
	wire [47:0] msj_corriente1;
	wire [47:0] msj_corriente2;
	wire [47:0] msj_corriente3;
	wire [47:0] msj_corriente4;
	wire [47:0] msj_corriente5;
	wire [47:0] msj_corriente6;
	
	wire [47:0] msj_angulo1;
	wire [47:0] msj_angulo2;
	wire [47:0] msj_angulo3;
	wire [47:0] msj_angulo4;
	wire [47:0] msj_angulo5;
	wire [47:0] msj_angulo6;
	wire [47:0] msj_angulo7;
	
	wire [47:0] msj_rpm1;
	wire [47:0] msj_rpm2;
	wire [47:0] msj_rpm3;
	wire [47:0] msj_rpm4;
	wire [47:0] msj_rpm5;
	wire [47:0] msj_rpm6;
	
//MODULOS
	
	creacion_mensaje mensaje_corriente1(Clock, corriente1, 1'b1, startBCD, "A" ,msj_corriente1, done_corriente1);
	creacion_mensaje mensaje_corriente2(Clock, corriente2, 1'b1, startBCD, "B", msj_corriente2, done_corriente2);
	creacion_mensaje mensaje_corriente3(Clock, corriente3, 1'b1, startBCD, "C", msj_corriente3, done_corriente3);
	creacion_mensaje mensaje_corriente4(Clock, corriente4, 1'b1, startBCD, "D", msj_corriente4, done_corriente4);
	creacion_mensaje mensaje_corriente5(Clock, corriente5, 1'b1, startBCD, "E", msj_corriente5, done_corriente5);
	creacion_mensaje mensaje_corriente6(Clock, corriente6, 1'b1, startBCD, "F", msj_corriente6, done_corriente6);


	creacion_mensaje mensaje_angulo1(Clock, angulo1, 1'b1, startBCD, "G", msj_angulo1, done_angulo1);
	creacion_mensaje mensaje_angulo2(Clock, angulo2, 1'b1, startBCD, "H", msj_angulo2, done_angulo2);
	creacion_mensaje mensaje_angulo3(Clock, angulo3, 1'b1, startBCD, "I", msj_angulo3, done_angulo3);
	creacion_mensaje mensaje_angulo4(Clock, angulo4, 1'b1, startBCD, "J", msj_angulo4, done_angulo4);
	creacion_mensaje mensaje_angulo5(Clock, angulo5, 1'b1, startBCD, "K", msj_angulo5, done_angulo5);
	creacion_mensaje mensaje_angulo6(Clock, angulo6, 1'b1, startBCD, "L", msj_angulo6, done_angulo6);
	creacion_mensaje mensaje_angulo7(Clock, angulo7, 1'b1, startBCD, "M", msj_angulo7, done_angulo7);

	
	creacion_mensaje mensaje_rpm1(Clock, A2_Bin_rpm1, signo_rpm1, startBCD, "N", msj_rpm1, done_rpm1);
	creacion_mensaje mensaje_rpm2(Clock, A2_Bin_rpm2, signo_rpm2, startBCD, "O", msj_rpm2, done_rpm2);
	creacion_mensaje mensaje_rpm3(Clock, A2_Bin_rpm3, signo_rpm3, startBCD, "P", msj_rpm3, done_rpm3);
	creacion_mensaje mensaje_rpm4(Clock, A2_Bin_rpm4, signo_rpm4, startBCD, "Q", msj_rpm4, done_rpm4);
	creacion_mensaje mensaje_rpm5(Clock, A2_Bin_rpm5, signo_rpm5, startBCD, "R", msj_rpm5, done_rpm5);
	creacion_mensaje mensaje_rpm6(Clock, A2_Bin_rpm6, signo_rpm6, startBCD, "S", msj_rpm6, done_rpm6);
	
	
	A2Bin A2Bin_rpm1(rpm1, A2_Bin_rpm1, signo_rpm1);
	A2Bin A2Bin_rpm2(rpm2, A2_Bin_rpm2, signo_rpm2);
	A2Bin A2Bin_rpm3(rpm3, A2_Bin_rpm3, signo_rpm3);
	A2Bin A2Bin_rpm4(rpm4, A2_Bin_rpm4, signo_rpm4);
	A2Bin A2Bin_rpm5(rpm5, A2_Bin_rpm5, signo_rpm5);
	A2Bin A2Bin_rpm6(rpm6, A2_Bin_rpm6, signo_rpm6);
	
	assign doneBCD = done_corriente1 & done_corriente2 & done_corriente3 & done_corriente4 & done_corriente5 & done_corriente6 & done_angulo1 & done_angulo2 & done_angulo3 & done_angulo4 & done_angulo5 & done_angulo6 & done_angulo7 & done_rpm1 & done_rpm2 & done_rpm3 & done_rpm4 & done_rpm5 & done_rpm6;
	assign mensaje = {msj_corriente1, msj_corriente2, msj_corriente3, msj_corriente4, msj_corriente5, msj_corriente6, msj_angulo1, msj_angulo2, msj_angulo3, msj_angulo4, msj_angulo5, msj_angulo6, msj_angulo7, msj_rpm1, msj_rpm2, msj_rpm3, msj_rpm4, msj_rpm5, msj_rpm6};
	
endmodule
