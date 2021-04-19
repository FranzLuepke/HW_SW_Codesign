module ROBOCOL_FINAL(

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_SCK,
	output		          		ADC_SDI,
	input 		          		ADC_SDO,

	//////////// ARDUINO //////////
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,

	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// SW //////////
	input 		     [3:0]		SW,

	//////////// GPIO_0, GPIO connect to GPIO Default //////////
		inout 		    [35:0]		GPIO_0GPIO,

	//////////// GPIO_1, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_1GPIO
);




//=======================================================
//  Structural coding
//=======================================================


// MUX WI-FI

wire salida_mux;

// Pin xBee / Pin Rpi / Pin select
mux mux1(GPIO_1GPIO[0], GPIO_1GPIO[2], GPIO_1GPIO[1], salida_mux);


// COMUNICACION XBEE UART 115200 bauds

wire rx_clear_Izquierda;
wire rx_clear_Derecha;
wire rx_clear_RGB;
wire rx_clear_Paso1;
wire rx_clear_Paso2;
wire rx_clear_Paso3;
wire rx_clear_Paso4;
wire rx_clear_Paso5;
wire rx_clear_Paso6;
wire rx_clear_Paso7;
wire rx_clear_servo1;
wire rx_clear_servo2;
wire rx_clear_servo3;
wire rx_clear_ENABLE;

wire rx_ready;
wire [7:0] rx_data;

// WIRES PARA CONEXIONES DE TRACCION Y BRAZO (RPM hace referencia a data)
wire [7:0] RPM_IZQUIERDA;
wire [7:0] RPM_DERECHA;
wire [7:0] RPM_RGB;
wire [7:0] RPM_Paso1;
wire [7:0] RPM_Paso2;
wire [7:0] RPM_Paso3;
wire [7:0] RPM_Paso4;
wire [7:0] RPM_Paso5;
wire [7:0] RPM_Paso6;
wire [7:0] RPM_Paso7;
wire [7:0] AnguloServo1;
wire [7:0] AnguloServo2;
wire [7:0] AnguloServo3;
wire [7:0] RPM_ENABLE;

wire [1:0] DIR_IZQUIERDA;
wire [1:0] DIR_DERECHA;
wire [1:0] DIR_RGB;
wire [1:0] DIR_Paso1;
wire [1:0] DIR_Paso2;
wire [1:0] DIR_Paso3;
wire [1:0] DIR_Paso4;
wire [1:0] DIR_Paso5;
wire [1:0] DIR_Paso6;
wire [1:0] DIR_Paso7;
wire [1:0] DIR_S1;
wire [1:0] DIR_S2;
wire [1:0] DIR_S3;
wire [1:0] DIR_ENABLE;




///////////// COMUNICACIONES /////////////

///// CONVERSION DE MENSAJES UART /////
wire Start_msj;
wire msj_done;
wire [911:0] mensaje_completo;
	
wire tx_busy;
wire Start_TX;
	
wire timer_done;
wire Start_Timer;
	
wire SH_done;
wire Start_SH;
	
wire [7:0] SH_REG_BUS_Out;


CreadorMensajeCompleto MensajeCompleto1(FPGA_CLK1_50,
	CH7, CH8, CH9, CH10, CH11, CH12, CH0, CH1, CH2, CH3, CH4, CH5, CH6, RPM_MEDIDO1, RPM_MEDIDO2, RPM_MEDIDO3, RPM_MEDIDO4, RPM_MEDIDO5, RPM_MEDIDO6,
	Start_msj, msj_done, mensaje_completo);
	
StateMachineTX StateMach1 (FPGA_CLK1_50, msj_done, tx_busy, timer_done, SH_done, Start_TX, Start_msj, Start_SH, Start_Timer);


TimerEspera Timer1(FPGA_CLK1_50, Start_Timer, timer_done);

		
SH_REG SH_REG1(SH_REG_BUS_Out, SH_done, FPGA_CLK1_50, mensaje_completo, Start_SH);



// MODULO UART DE CONEXION A RPI Y XBEE

uart uartModule(SH_REG_BUS_Out,
	    Start_TX,
	    FPGA_CLK1_50,
	    GPIO_1GPIO[32],
	    tx_busy,
	    salida_mux, //CONECTAR RX (Salida del mux de seleccion entre Rpi y Xbee)
	    rx_ready,//rx_rdy (Indica que el byte esta listo para ser leido)
	    rx_clear_Izquierda || rx_clear_Derecha || rx_clear_RGB || rx_clear_Paso1 || rx_clear_Paso2 || rx_clear_Paso3 || rx_clear_Paso4 || rx_clear_Paso5 || rx_clear_Paso6 || rx_clear_Paso7 || rx_clear_servo1 || rx_clear_servo2 || rx_clear_servo3 || rx_clear_ENABLE,//Limpia la bandera de byte listo
	    rx_data);//Byte de salida

		 
// CONTROLADOR DE TRANSMISION A RPI


///////////// TRACCION /////////////


// DETECTORES PARA TRACCION
Detector_Mensajes detectorIzquierda(rx_ready, rx_clear_Izquierda, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_IZQUIERDA, DIR_IZQUIERDA, 8'd76); //Detectar la L d76
Detector_Mensajes detectorDerecha(rx_ready, rx_clear_Derecha, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_DERECHA, DIR_DERECHA, 8'd82); //Detectar la R d82

// DEBOUNCERS ENCODERS //

//MOTOR 1
wire DB1_A;
wire DB1_B;
DeBounce1 DB1_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[4] ,DB1_A);
DeBounce1 DB1_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[5] ,DB1_B);

//MOTOR 2
wire DB2_A;
wire DB2_B;
DeBounce1 DB2_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[2] ,DB2_A);
DeBounce1 DB2_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[3] ,DB2_B);

//MOTOR 3
wire DB3_A;
wire DB3_B;
DeBounce1 DB3_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[0] ,DB3_A);
DeBounce1 DB3_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[1] ,DB3_B);

//MOTOR 4
wire DB4_A;
wire DB4_B;
DeBounce1 DB4_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[6] ,DB4_A);
DeBounce1 DB4_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[7] ,DB4_B);

//MOTOR 5
wire DB5_A;
wire DB5_B;
DeBounce1 DB5_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[8] ,DB5_A);
DeBounce1 DB5_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[9] ,DB5_B);

//MOTOR 6
wire DB6_A;
wire DB6_B;
DeBounce1 DB6_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[10] ,DB6_A);
DeBounce1 DB6_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[11] ,DB6_B);


// CONEXIONES PID MOTORES

//Cuentas encoders
wire signed [35:0] Count1;
wire signed [35:0] Count2;
wire signed [35:0] Count3;
wire signed [35:0] Count4;
wire signed [35:0] Count5;
wire signed [35:0] Count6;

//CLOCK 5ms
wire CLK_scaled;

//Medicion RPM
wire signed [15:0] RPM_MEDIDO1;
wire signed [15:0] RPM_MEDIDO2;
wire signed [15:0] RPM_MEDIDO3;
wire signed [15:0] RPM_MEDIDO4;
wire signed [15:0] RPM_MEDIDO5;
wire signed [15:0] RPM_MEDIDO6;

//Datos de control PWM
wire [7:0] PWM_DATA1;
wire [7:0] PWM_DATA2;
wire [7:0] PWM_DATA3;
wire [7:0] PWM_DATA4;
wire [7:0] PWM_DATA5;
wire [7:0] PWM_DATA6;

//Datos para los LEDs RGB
wire [7:0] PWM_R;
wire [7:0] PWM_G;
wire [7:0] PWM_B;

//Modulo de conteo de Encoders (cuentas totales del encoder)
Encoder Encoder1(FPGA_CLK1_50, DB1_A, DB1_B, Count1);
Encoder Encoder2(FPGA_CLK1_50, DB2_A, DB2_B, Count2);
Encoder Encoder3(FPGA_CLK1_50, DB3_A, DB3_B, Count3);
Encoder Encoder4(FPGA_CLK1_50, DB4_A, DB4_B, Count4);
Encoder Encoder5(FPGA_CLK1_50, DB5_A, DB5_B, Count5);
Encoder Encoder6(FPGA_CLK1_50, DB6_A, DB6_B, Count6);


//Clock a 5ms (prescaller)
Prescaller Prescaller5ms(!KEY[0], FPGA_CLK1_50, CLK_scaled, 125000);


//Medidores de RPM a partir de senal de encoders (derivador usando 5ms como h)
RPM RPM1(CLK_scaled, Count1, RPM_MEDIDO1);
RPM RPM2(CLK_scaled, Count2, RPM_MEDIDO2);
RPM RPM3(CLK_scaled, Count3, RPM_MEDIDO3);
RPM RPM4(CLK_scaled, Count4, RPM_MEDIDO4);
RPM RPM5(CLK_scaled, Count5, RPM_MEDIDO5);
RPM RPM6(CLK_scaled, Count6, RPM_MEDIDO6);

//Controladores PI para RPM en traccion
PID_control PID_control1(CLK_scaled, $signed( $signed({8'b0,RPM_IZQUIERDA})*$signed(DIR_IZQUIERDA) ) , RPM_MEDIDO1, GPIO_0GPIO[18], GPIO_0GPIO[19], PWM_DATA1);
PID_control PID_control2(CLK_scaled, $signed( $signed({8'b0,RPM_IZQUIERDA})*$signed(DIR_IZQUIERDA) ) , RPM_MEDIDO2, GPIO_0GPIO[20], GPIO_0GPIO[21], PWM_DATA2);
PID_control PID_control3(CLK_scaled, $signed( $signed({8'b0,RPM_IZQUIERDA})*$signed(DIR_IZQUIERDA) ) , RPM_MEDIDO3, GPIO_0GPIO[22], GPIO_0GPIO[23], PWM_DATA3);

PID_control PID_control4(CLK_scaled, $signed( $signed({8'b0,RPM_DERECHA})*$signed(DIR_DERECHA) ) , -RPM_MEDIDO4, GPIO_0GPIO[24], GPIO_0GPIO[25], PWM_DATA4);
PID_control PID_control5(CLK_scaled, $signed( $signed({8'b0,RPM_DERECHA})*$signed(DIR_DERECHA) ) , -RPM_MEDIDO5, GPIO_0GPIO[26], GPIO_0GPIO[27], PWM_DATA5);
PID_control PID_control6(CLK_scaled, $signed( $signed({8'b0,RPM_DERECHA})*$signed(DIR_DERECHA) ) , -RPM_MEDIDO6, GPIO_0GPIO[28], GPIO_0GPIO[29], PWM_DATA6);

//Generadores de PWM para traccion (generan la senal de control como un PWM)
moduloPWM PWM1(!KEY[0], FPGA_CLK1_50, PWM_DATA1, GPIO_0GPIO[12]);
moduloPWM PWM2(!KEY[0], FPGA_CLK1_50, PWM_DATA2, GPIO_0GPIO[13]);
moduloPWM PWM3(!KEY[0], FPGA_CLK1_50, PWM_DATA3, GPIO_0GPIO[14]);
moduloPWM PWM4(!KEY[0], FPGA_CLK1_50, PWM_DATA4, GPIO_0GPIO[15]);
moduloPWM PWM5(!KEY[0], FPGA_CLK1_50, PWM_DATA5, GPIO_0GPIO[16]);
moduloPWM PWM6(!KEY[0], FPGA_CLK1_50, PWM_DATA6, GPIO_0GPIO[17]);

//Enable's para motores DC (traccion)

wire EN1, EN2, EN3, EN4, EN5, EN6;

Detector_Mensajes_01 detectorEnable(rx_ready, rx_clear_ENABLE, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_ENABLE, DIR_ENABLE, 8'd73); //Detectar la I
moduloEnableMotores enMot1(FPGA_CLK1_50, RPM_ENABLE, DIR_ENABLE, EN1, EN2, EN3, EN4, EN5, EN6);

assign GPIO_0GPIO[30] = EN1;
assign GPIO_0GPIO[31] = EN2;
assign GPIO_0GPIO[32] = EN3;
assign GPIO_0GPIO[33] = EN4;
assign GPIO_0GPIO[34] = EN5;
assign GPIO_0GPIO[35] = EN6;

assign LED = {EN6,EN5,EN4,EN3,EN2,EN1};


///////////// LEDS RGB DE SEGURIDAD /////////////

Detector_Mensajes detectorInicio(rx_ready, rx_clear_RGB, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_RGB, DIR_RGB, 8'd65); //Detectar la A
ModuloControlRGB mod1(RPM_RGB, PWM_R, PWM_G, PWM_B, FPGA_CLK1_50);
moduloPWM R(!KEY[0], FPGA_CLK1_50, PWM_R, GPIO_1GPIO[3]);
moduloPWM G(!KEY[0], FPGA_CLK1_50, PWM_G, GPIO_1GPIO[4]);
moduloPWM B(!KEY[0], FPGA_CLK1_50, PWM_B, GPIO_1GPIO[5]);

///////////// BRAZO /////////////


//SERVOS
Detector_Mensajes detectorServo1(rx_ready, rx_clear_servo1, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, AnguloServo1, DIR_S1, 8'd83); //Detectar la S
Detector_Mensajes detectorServo2(rx_ready, rx_clear_servo2, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, AnguloServo2, DIR_S2, 8'd84); //Detectar la T
Detector_Mensajes detectorServo3(rx_ready, rx_clear_servo3, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, AnguloServo3, DIR_S3, 8'd85); //Detectar la U

control_servo servo1(!KEY[0], FPGA_CLK1_50, AnguloServo1, GPIO_1GPIO[6]);
control_servo servo2(!KEY[0], FPGA_CLK1_50, AnguloServo2, GPIO_1GPIO[7]);
control_servo servo3(!KEY[0], FPGA_CLK1_50, AnguloServo3, GPIO_1GPIO[8]);


//CONTROL ADC

wire [11:0] CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12;

ADC_interface ADC_MODULE(FPGA_CLK1_50, ADC_CONVST, ADC_SCK, ADC_SDI, ADC_SDO, {GPIO_1GPIO[33], GPIO_1GPIO[31], GPIO_1GPIO[30]}, CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12);


//STEPPERS


// CONTROL MANUAL

Detector_Mensajes_stepper detectorStepper1(rx_ready, rx_clear_Paso1, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso1, GPIO_1GPIO[17], 8'd66); //Detectar la B
Detector_Mensajes_stepper detectorStepper2(rx_ready, rx_clear_Paso2, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso2, GPIO_1GPIO[16], 8'd67); //Detectar la C
Detector_Mensajes_stepper detectorStepper3(rx_ready, rx_clear_Paso3, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso3, GPIO_1GPIO[19], 8'd68); //Detectar la D
Detector_Mensajes_stepper detectorStepper4(rx_ready, rx_clear_Paso4, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso4, GPIO_1GPIO[18], 8'd69); //Detectar la E
Detector_Mensajes_stepper detectorStepper5(rx_ready, rx_clear_Paso5, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso5, GPIO_1GPIO[21], 8'd70); //Detectar la F
Detector_Mensajes_stepper detectorStepper6(rx_ready, rx_clear_Paso6, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso6, GPIO_1GPIO[20], 8'd71); //Detectar la G
Detector_Mensajes_stepper detectorStepper7(rx_ready, rx_clear_Paso7, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso7, GPIO_1GPIO[23], 8'd72); //Detectar la H

prescaller_stepper p1(0, FPGA_CLK1_50, GPIO_1GPIO[9], RPM_Paso1);
prescaller_stepper p2(0, FPGA_CLK1_50, GPIO_1GPIO[11], RPM_Paso2);
prescaller_stepper p3(0, FPGA_CLK1_50, GPIO_1GPIO[10], RPM_Paso3);
prescaller_stepper p4(0, FPGA_CLK1_50, GPIO_1GPIO[13], RPM_Paso4);
prescaller_stepper p5(0, FPGA_CLK1_50, GPIO_1GPIO[12], RPM_Paso5);
prescaller_stepper p6(0, FPGA_CLK1_50, GPIO_1GPIO[15], RPM_Paso6);
prescaller_stepper p7(0, FPGA_CLK1_50, GPIO_1GPIO[14], RPM_Paso7);

assign GPIO_1GPIO[22] = 0;
assign GPIO_1GPIO[25] = 0;
assign GPIO_1GPIO[24] = 0;
assign GPIO_1GPIO[27] = 0;
assign GPIO_1GPIO[26] = 0;
assign GPIO_1GPIO[29] = 0;
assign GPIO_1GPIO[28] = 0;







// CONTROL DE ANGULO

//wire [7:0] Senial_control1, Senial_control2, Senial_control3, Senial_control4, Senial_control5, Senial_control6, Senial_control7;
//wire b0, b1, b2, b3, b4, b5, b6;

//Detector_Mensajes_stepper detectorStepper1(rx_ready, rx_clear_Paso1, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso1, b0, 8'd66); //Detectar la B
//Detector_Mensajes_stepper detectorStepper2(rx_ready, rx_clear_Paso2, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso2, b1, 8'd67); //Detectar la C
//Detector_Mensajes_stepper detectorStepper3(rx_ready, rx_clear_Paso3, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso3, b2, 8'd68); //Detectar la D
//Detector_Mensajes_stepper detectorStepper4(rx_ready, rx_clear_Paso4, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso4, b3, 8'd69); //Detectar la E
//Detector_Mensajes_stepper detectorStepper5(rx_ready, rx_clear_Paso5, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso5, b4, 8'd70); //Detectar la F
//Detector_Mensajes_stepper detectorStepper6(rx_ready, rx_clear_Paso6, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso6, b5, 8'd71); //Detectar la G
//Detector_Mensajes_stepper detectorStepper7(rx_ready, rx_clear_Paso7, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_Paso7, b6, 8'd72); //Detectar la H


//controladorPosicion pos1(FPGA_CLK1_50, CH0, RPM_Paso1, Senial_control1, GPIO_1GPIO[17], 100, 2);
//controladorPosicion pos2(FPGA_CLK1_50, CH1, RPM_Paso2, Senial_control2, GPIO_1GPIO[16], 100, 2);
//controladorPosicion pos3(FPGA_CLK1_50, CH2, RPM_Paso3, Senial_control3, GPIO_1GPIO[19], 100, 2);
//controladorPosicion pos4(FPGA_CLK1_50, CH3, RPM_Paso4, Senial_control4, GPIO_1GPIO[18], 10, 2);
//controladorPosicion pos5(FPGA_CLK1_50, CH4, RPM_Paso5, Senial_control5, GPIO_1GPIO[21], 10, 2);
//controladorPosicion pos6(FPGA_CLK1_50, CH5, RPM_Paso6, Senial_control6, GPIO_1GPIO[20], 10, 2);
//controladorPosicion pos7(FPGA_CLK1_50, CH6, RPM_Paso7, Senial_control7, GPIO_1GPIO[23], 10, 2);


//prescaller_stepper p1(0, FPGA_CLK1_50, GPIO_1GPIO[9], Senial_control1);
//prescaller_stepper p2(0, FPGA_CLK1_50, GPIO_1GPIO[11], Senial_control2);
//prescaller_stepper p3(0, FPGA_CLK1_50, GPIO_1GPIO[10], Senial_control3);
//prescaller_stepper p4(0, FPGA_CLK1_50, GPIO_1GPIO[13], Senial_control4);
//prescaller_stepper p5(0, FPGA_CLK1_50, GPIO_1GPIO[12], Senial_control5);
//prescaller_stepper p6(0, FPGA_CLK1_50, GPIO_1GPIO[15], Senial_control6);
//prescaller_stepper p7(0, FPGA_CLK1_50, GPIO_1GPIO[14], Senial_control7);


endmodule
