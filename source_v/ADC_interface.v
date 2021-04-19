module ADC_interface(clock, ADC_CONVST, ADC_SCK, ADC_SDI, ADC_SDO, MUX_CONTROL, CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12);


input clock, ADC_SDO;
output ADC_CONVST, ADC_SCK, ADC_SDI;
output [2:0] MUX_CONTROL;
output [11:0] CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12 = 12'd0;


ControlSDI ctSDI1(flag, ADC_SCK, ADC_SDI, CH_ACTUAL, MUX_CONTROL);


reg [11:0] datosRecibidos = 0;
reg [11:0] CH0, CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12;
reg ADC_CONVST;
reg rst = 1;
wire flag;
wire [3:0] CH_ACTUAL;


Prescaller P1(rst, clock, ADC_SCK, 250);
contador contadorSubida(rst, clock, 6100, flag);


parameter ESTADO_0=2'd0;
parameter ESTADO_1=2'd1;
parameter ESTADO_2=2'd2;

reg [1:0] estado_actual=ESTADO_0;
reg [1:0] estado_futuro=ESTADO_0;

//Logica secuencial
always@(posedge clock)
begin
	if(flag)
		begin
			estado_actual<=ESTADO_0;
			case(CH_ACTUAL)
			
				4'd0: CH0 <= datosRecibidos;
				4'd1: CH1 <= datosRecibidos;
				4'd2: CH2 <= datosRecibidos;
				4'd3: CH3 <= datosRecibidos;
				4'd4: CH4 <= datosRecibidos;
				4'd5: CH5 <= datosRecibidos;
				4'd6: CH6 <= datosRecibidos;
				4'd7: CH7 <= datosRecibidos;
				4'd8: CH8 <= datosRecibidos;
				4'd9: CH9 <= datosRecibidos;
				4'd10: CH10 <= datosRecibidos;
				4'd11: CH11 <= datosRecibidos;
				4'd12: CH12 <= datosRecibidos;
				default:
				begin
					CH0 <= CH0;
					CH1 <= CH1;
					CH2 <= CH2;
					CH3 <= CH3;
					CH4 <= CH4;
					CH5 <= CH5;
					CH6 <= CH6;
					CH7 <= CH7;
					CH8 <= CH8;
					CH9 <= CH9;
					CH10 <= CH10;
					CH11 <= CH11;
					CH12 <= CH12;
				end
		
			endcase
		end
		
		
		
	else
		begin
			estado_actual<=estado_futuro;
			CH0 <= CH0;
			CH1 <= CH1;
			CH2 <= CH2;
			CH3 <= CH3;
			CH4 <= CH4;
			CH5 <= CH5;
			CH6 <= CH6;
			CH7 <= CH7;
			CH8 <= CH8;
			CH9 <= CH9;
			CH10 <= CH10;
			CH11 <= CH11;
			CH12 <= CH12;
		end
end

// SEQUENTIAL NEW CLOCK
always @ (posedge ADC_SCK)
begin
	datosRecibidos<={datosRecibidos[10:0], ADC_SDO};
end


//Logica combinacional de estados
always@(*)
begin
case(estado_actual)
ESTADO_0:begin
				estado_futuro=ESTADO_1;
			end
ESTADO_1:begin
				estado_futuro=ESTADO_2;
			end
ESTADO_2:begin
				estado_futuro=ESTADO_2;
			end

default:estado_futuro=ESTADO_0;
endcase
end

//Logica combinacional de salidas
always@(*)
begin
case(estado_actual)

ESTADO_0: 
	begin
		rst = 1;
		ADC_CONVST = 0;
	end
ESTADO_1: 
	begin
		rst = 1;
		ADC_CONVST = 1;
	end
ESTADO_2: 
	begin
		rst = 0;
		ADC_CONVST = 0;
	end

default: 
	begin
		rst = 1;
		ADC_CONVST = 0;
	end

endcase
end


endmodule
