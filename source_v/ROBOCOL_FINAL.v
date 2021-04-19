module ROBOCOL_FINAL
(
	//////////// CLOCK //////////
	input					FPGA_CLK1_50,
	input					FPGA_CLK2_50,
	input					FPGA_CLK3_50,
	//////////// ADC //////////
	input					ADC_SDO,
	output				ADC_CONVST,
	output				ADC_SCK,
	output				ADC_SDI,
	//////////// ARDUINO //////////
	inout		[15:0]	ARDUINO_IO,
	inout					ARDUINO_RESET_N,
	//////////// KEY //////////
	input		[1:0]		KEY,
	//////////// LED //////////
	output	[7:0]		LED,
	//////////// SW //////////
	input		[3:0]		SW,
	//////////// GPIO_0, GPIO connect to GPIO Default //////////
	inout		[35:0]	GPIO_0GPIO,
	//////////// GPIO_1, GPIO connect to GPIO Default //////////
	inout		[35:0]	GPIO_1GPIO
);
//=======================================================
//  Structural coding
//=======================================================
// MUX WI-FI
wire salida_mux;
// XBee pin / RPi Pin / Select pin
mux mux1(GPIO_1GPIO[0], GPIO_1GPIO[2], GPIO_1GPIO[1], salida_mux);
// UART communication at 115200 bauds
wire rx_clear_Izquierda;
wire rx_clear_Derecha;
wire rx_clear_ENABLE;
wire rx_ready;
wire [7:0] rx_data;
// TRACTION WIRES
wire [7:0] RPM_L;
wire [7:0] RPM_R;
wire [7:0] RPM_ENABLE;
wire [1:0] DIR_L;
wire [1:0] DIR_R;
wire [1:0] DIR_ENABLE;
///////////// COMMUNICATIONS /////////////
///// UART MESSAGES CONVERSION/////
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
// Messages creator
CreadorMensajeCompleto MensajeCompleto1(FPGA_CLK1_50,
	CH7, CH8, CH9, CH10, CH11, CH12, CH0, CH1, CH2, CH3, CH4, CH5, CH6, RPM_MEDIDO1, RPM_MEDIDO2, RPM_MEDIDO3, RPM_MEDIDO4, RPM_MEDIDO5, RPM_MEDIDO6,
	Start_msj, msj_done, mensaje_completo);
// State machine
StateMachineTX StateMach1 (FPGA_CLK1_50, msj_done, tx_busy, timer_done, SH_done, Start_TX, Start_msj, Start_SH, Start_Timer);
// Wait timer
TimerEspera Timer1(FPGA_CLK1_50, Start_Timer, timer_done);
// SH Reg
SH_REG SH_REG1(SH_REG_BUS_Out, SH_done, FPGA_CLK1_50, mensaje_completo, Start_SH);
// UART module
uart uartModule
(SH_REG_BUS_Out,
	    Start_TX,
	    FPGA_CLK1_50,
	    GPIO_1GPIO[32],
	    tx_busy,
	    salida_mux, // RX connect (Mux output to select in)
	    rx_ready, // rx_rdy (Indicates byte is ready to be read)
	    rx_clear_Izquierda || rx_clear_Derecha || rx_clear_ENABLE, // Cleans byte ready flag
	    rx_data
);

///////////// TRACTION /////////////
// TRACTION MESSAGE DETECTORS
// Detect L (d76)
Detector_Mensajes detectorIzquierda(rx_ready, rx_clear_Izquierda, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_L, DIR_L, 8'd76);
// Detect R (d82)
Detector_Mensajes detectorDerecha(rx_ready, rx_clear_Derecha, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_R, DIR_R, 8'd82);
// DEBOUNCERS ENCODERS //
wire DB1_A, DB1_B, DB2_A, DB2_B, DB3_A, DB3_B, DB4_A, DB4_B, DB5_A, DB5_B, DB6_A, DB6_B;
// MOTOR 1
DeBounce1 DB1_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[4] ,DB1_A);
DeBounce1 DB1_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[5] ,DB1_B);
// MOTOR 2
DeBounce1 DB2_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[2] ,DB2_A);
DeBounce1 DB2_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[3] ,DB2_B);
// MOTOR 3
DeBounce1 DB3_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[0] ,DB3_A);
DeBounce1 DB3_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[1] ,DB3_B);
// MOTOR 4
DeBounce1 DB4_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[6] ,DB4_A);
DeBounce1 DB4_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[7] ,DB4_B);
// MOTOR 5
DeBounce1 DB5_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[8] ,DB5_A);
DeBounce1 DB5_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[9] ,DB5_B);
// MOTOR 6
DeBounce1 DB6_MA(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[10] ,DB6_A);
DeBounce1 DB6_MB(FPGA_CLK1_50, !KEY[0], GPIO_0GPIO[11] ,DB6_B);
// PID CONNECTIONS
// Wire for 5ms clock
wire CLK_scaled;
// Wires for enconder counts
wire signed [35:0] Count1, Count2, Count3, Count4, Count5, Count6;
// Wires for RPM measurement
wire signed [15:0] RPM_MEDIDO1, RPM_MEDIDO2, RPM_MEDIDO3, RPM_MEDIDO4, RPM_MEDIDO5, RPM_MEDIDO6;
// PWM control data
wire [7:0] PWM_DATA1, PWM_DATA2, PWM_DATA3, PWM_DATA4, PWM_DATA5, PWM_DATA6;
// Encoders counter (Total encoder counts)
Encoder Encoder1(FPGA_CLK1_50, DB1_A, DB1_B, Count1);
Encoder Encoder2(FPGA_CLK1_50, DB2_A, DB2_B, Count2);
Encoder Encoder3(FPGA_CLK1_50, DB3_A, DB3_B, Count3);
Encoder Encoder4(FPGA_CLK1_50, DB4_A, DB4_B, Count4);
Encoder Encoder5(FPGA_CLK1_50, DB5_A, DB5_B, Count5);
Encoder Encoder6(FPGA_CLK1_50, DB6_A, DB6_B, Count6);
// 5 ms clock (prescaller)
Prescaller Prescaller5ms(!KEY[0], FPGA_CLK1_50, CLK_scaled, 125000);
// RPM measurements from encoder signals (derivative using 5ms as h)
RPM RPM1(CLK_scaled, Count1, RPM_MEDIDO1);
RPM RPM2(CLK_scaled, Count2, RPM_MEDIDO2);
RPM RPM3(CLK_scaled, Count3, RPM_MEDIDO3);
RPM RPM4(CLK_scaled, Count4, RPM_MEDIDO4);
RPM RPM5(CLK_scaled, Count5, RPM_MEDIDO5);
RPM RPM6(CLK_scaled, Count6, RPM_MEDIDO6);
// PID controllers for RPM
PID_control PID_control1(CLK_scaled, $signed($signed({8'b0,RPM_L})*$signed(DIR_L)),  RPM_MEDIDO1, GPIO_0GPIO[18], GPIO_0GPIO[19], PWM_DATA1);
PID_control PID_control2(CLK_scaled, $signed($signed({8'b0,RPM_L})*$signed(DIR_L)),  RPM_MEDIDO2, GPIO_0GPIO[20], GPIO_0GPIO[21], PWM_DATA2);
PID_control PID_control3(CLK_scaled, $signed($signed({8'b0,RPM_L})*$signed(DIR_L)),  RPM_MEDIDO3, GPIO_0GPIO[22], GPIO_0GPIO[23], PWM_DATA3);
PID_control PID_control4(CLK_scaled, $signed($signed({8'b0,RPM_R})*$signed(DIR_R)), -RPM_MEDIDO4, GPIO_0GPIO[24], GPIO_0GPIO[25], PWM_DATA4);
PID_control PID_control5(CLK_scaled, $signed($signed({8'b0,RPM_R})*$signed(DIR_R)), -RPM_MEDIDO5, GPIO_0GPIO[26], GPIO_0GPIO[27], PWM_DATA5);
PID_control PID_control6(CLK_scaled, $signed($signed({8'b0,RPM_R})*$signed(DIR_R)), -RPM_MEDIDO6, GPIO_0GPIO[28], GPIO_0GPIO[29], PWM_DATA6);
// PWM generators (control signal generation with PWM)
moduloPWM PWM1(!KEY[0], FPGA_CLK1_50, PWM_DATA1, GPIO_0GPIO[12]);
moduloPWM PWM2(!KEY[0], FPGA_CLK1_50, PWM_DATA2, GPIO_0GPIO[13]);
moduloPWM PWM3(!KEY[0], FPGA_CLK1_50, PWM_DATA3, GPIO_0GPIO[14]);
moduloPWM PWM4(!KEY[0], FPGA_CLK1_50, PWM_DATA4, GPIO_0GPIO[15]);
moduloPWM PWM5(!KEY[0], FPGA_CLK1_50, PWM_DATA5, GPIO_0GPIO[16]);
moduloPWM PWM6(!KEY[0], FPGA_CLK1_50, PWM_DATA6, GPIO_0GPIO[17]);
// DC motors enable signals.
wire EN1, EN2, EN3, EN4, EN5, EN6;
// Enable signals detector
// Detect I (d73)
Detector_Mensajes_01 detectorEnable(rx_ready, rx_clear_ENABLE, {1'b0,rx_data[6:0]}, FPGA_CLK1_50, RPM_ENABLE, DIR_ENABLE, 8'd73);
moduloEnableMotores enMot1(FPGA_CLK1_50, RPM_ENABLE, DIR_ENABLE, EN1, EN2, EN3, EN4, EN5, EN6);
// Enable signals assign to GPIO
assign GPIO_0GPIO[30] = EN1;
assign GPIO_0GPIO[31] = EN2;
assign GPIO_0GPIO[32] = EN3;
assign GPIO_0GPIO[33] = EN4;
assign GPIO_0GPIO[34] = EN5;
assign GPIO_0GPIO[35] = EN6;
// Enables assignment to GPIO.
assign LED = {EN6,EN5,EN4,EN3,EN2,EN1};
// ADC CONTROL
wire [11:0] CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12;
ADC_interface ADC_MODULE(FPGA_CLK1_50, ADC_CONVST, ADC_SCK, ADC_SDI, ADC_SDO, {GPIO_1GPIO[33], GPIO_1GPIO[31], GPIO_1GPIO[30]}, CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12);
// Unused GPIO pins to 0
assign GPIO_1GPIO[3]  = 0;
assign GPIO_1GPIO[4]  = 0;
assign GPIO_1GPIO[5]  = 0;
assign GPIO_1GPIO[6]  = 0;
assign GPIO_1GPIO[7]  = 0;
assign GPIO_1GPIO[8]  = 0;
assign GPIO_1GPIO[16] = 0;
assign GPIO_1GPIO[17] = 0;
assign GPIO_1GPIO[18] = 0;
assign GPIO_1GPIO[19] = 0;
assign GPIO_1GPIO[20] = 0;
assign GPIO_1GPIO[21] = 0;
assign GPIO_1GPIO[22] = 0;
assign GPIO_1GPIO[23] = 0;
assign GPIO_1GPIO[24] = 0;
assign GPIO_1GPIO[25] = 0;
assign GPIO_1GPIO[26] = 0;
assign GPIO_1GPIO[27] = 0;
assign GPIO_1GPIO[28] = 0;
assign GPIO_1GPIO[29] = 0;

endmodule
