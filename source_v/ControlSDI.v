module ControlSDI(flag, ADC_SCK, ADC_SDI, CH_ACTUAL, MUX_CONTROL);

parameter SD = 1'b1;
parameter UNI = 1'b1;
parameter SLP = 1'b0;

parameter OS_BIT_OPTIONS = 13'b0111111010101;
parameter s1_BIT_OPTIONS = 13'b0111111111000;
parameter s0_BIT_OPTIONS = 13'b0111111100110;


input flag, ADC_SCK;
output [3:0] CH_ACTUAL;
output ADC_SDI;
output [2:0] MUX_CONTROL;


wire [3:0] CH_ACTUAL;
reg ADC_SDI = 1;
reg [2:0] MUX_CONTROL = 0;

assign CH_ACTUAL = estado_actual;

wire OS_BIT;
wire S1_BIT;
wire S0_BIT;
assign OS_BIT = OS_BIT_OPTIONS[estado_actual];
assign S1_BIT = s1_BIT_OPTIONS[estado_actual];
assign S0_BIT = s0_BIT_OPTIONS[estado_actual];

parameter ESTADO_CH0=4'd0;
parameter ESTADO_CH1=4'd1;
parameter ESTADO_CH2=4'd2;
parameter ESTADO_CH3=4'd3;
parameter ESTADO_CH4=4'd4;
parameter ESTADO_CH5=4'd5;
parameter ESTADO_CH6=4'd6;
parameter ESTADO_CH7=4'd7;
parameter ESTADO_CH8=4'd8;
parameter ESTADO_CH9=4'd9;
parameter ESTADO_CH10=4'd10;
parameter ESTADO_CH11=4'd11;
parameter ESTADO_CH12=4'd12;

reg [3:0] estado_actual=ESTADO_CH0;
reg [3:0] estado_futuro=ESTADO_CH0;


// SEQUENTIAL NEW CLOCK
always @ (negedge flag)
begin
	estado_actual<=estado_futuro;
end


//Logica combinacional de estados
always@(*)
begin
	case(estado_actual)
		ESTADO_CH0:estado_futuro=ESTADO_CH1;
		ESTADO_CH1:estado_futuro=ESTADO_CH2;
		ESTADO_CH2:estado_futuro=ESTADO_CH3;
		ESTADO_CH3:estado_futuro=ESTADO_CH4;
		ESTADO_CH4:estado_futuro=ESTADO_CH5;
		ESTADO_CH5:estado_futuro=ESTADO_CH6;
		ESTADO_CH6:estado_futuro=ESTADO_CH7;
		ESTADO_CH7:estado_futuro=ESTADO_CH8;
		ESTADO_CH8:estado_futuro=ESTADO_CH9;
		ESTADO_CH9:estado_futuro=ESTADO_CH10;
		ESTADO_CH10:estado_futuro=ESTADO_CH11;
		ESTADO_CH11:estado_futuro=ESTADO_CH12;
		ESTADO_CH12:estado_futuro=ESTADO_CH0;
		default:estado_futuro=ESTADO_CH0;
	endcase
end

//Logica SECUENCIAL de salidas
always@(posedge ADC_SCK)
begin
	case(estado_actual)

		ESTADO_CH6: MUX_CONTROL <= 3'd0;
		ESTADO_CH7: MUX_CONTROL <= 3'd1;
		ESTADO_CH8: MUX_CONTROL <= 3'd2;
		ESTADO_CH9: MUX_CONTROL <= 3'd3;
		ESTADO_CH10: MUX_CONTROL <= 3'd4;
		ESTADO_CH11: MUX_CONTROL <= 3'd5;

		default: MUX_CONTROL = 3'd0;

	endcase
end



//Control de la senial SDI

parameter ESTADO_0=4'd0;
parameter ESTADO_1=4'd1;
parameter ESTADO_2=4'd2;
parameter ESTADO_3=4'd3;
parameter ESTADO_4=4'd4;
parameter ESTADO_5=4'd5;
parameter ESTADO_6=4'd6;
parameter ESTADO_7=4'd7;
parameter ESTADO_8=4'd8;
parameter ESTADO_9=4'd9;
parameter ESTADO_10=4'd10;
parameter ESTADO_11=4'd11;

reg [3:0] estado_actual_SDI = ESTADO_0;
reg [3:0] estado_futuro_SDI = ESTADO_0;

always @ (negedge ADC_SCK)
begin
	estado_actual_SDI<=estado_futuro_SDI;
end


always@(*)
begin
	case(estado_actual_SDI)
		ESTADO_0:estado_futuro_SDI=ESTADO_1;
		ESTADO_1:estado_futuro_SDI=ESTADO_2;
		ESTADO_2:estado_futuro_SDI=ESTADO_3;
		ESTADO_3:estado_futuro_SDI=ESTADO_4;
		ESTADO_4:estado_futuro_SDI=ESTADO_5;
		ESTADO_5:estado_futuro_SDI=ESTADO_6;
		ESTADO_6:estado_futuro_SDI=ESTADO_7;
		ESTADO_7:estado_futuro_SDI=ESTADO_8;
		ESTADO_8:estado_futuro_SDI=ESTADO_9;
		ESTADO_9:estado_futuro_SDI=ESTADO_10;
		ESTADO_10:estado_futuro_SDI=ESTADO_11;
		ESTADO_11:estado_futuro_SDI=ESTADO_0;
		default:estado_futuro_SDI=ESTADO_0;
	endcase
end



always@(*)
begin
	case(estado_actual_SDI)

		ESTADO_0:ADC_SDI = SD;
		ESTADO_1:ADC_SDI = OS_BIT;
		ESTADO_2:ADC_SDI = S1_BIT;
		ESTADO_3:ADC_SDI = S0_BIT;
		ESTADO_4:ADC_SDI = UNI;
		ESTADO_5:ADC_SDI = SLP;
		ESTADO_6:ADC_SDI = SD;
		ESTADO_7:ADC_SDI = SD;
		ESTADO_8:ADC_SDI = SD;
		ESTADO_9:ADC_SDI = SD;
		ESTADO_10:ADC_SDI = SD;
		ESTADO_11:ADC_SDI = SD;

		default: ADC_SDI = 1'b1;

	endcase
end


endmodule
