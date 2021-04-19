//Este modulo realiza toda la recepcion de datos por UART
//Realiza 16 muestreos por cada bit para estar seguro de capturar el correcto
//Se basa en una maquina de estados, que recibe bit a bit hasta que complete los 8, que componen el byte de salida
//Esta en ingles, ya que es basado en un codigo libre de internet
module receiver(input wire rx,
		output reg rdy,
		input wire rdy_clr,
		input wire clk_50m,
		input wire clken,
		output reg [7:0] data);

//Inicializacion
initial begin
	rdy = 0;
	data = 8'b0;
end

//Estados de la maquina
parameter RX_STATE_START	= 2'b00; //Inicio de la transmision
parameter RX_STATE_DATA		= 2'b01; //Recibiendo datos
parameter RX_STATE_STOP		= 2'b10; //Fin de transmision

reg [1:0] state = RX_STATE_START; //Estado actual
reg [3:0] sample = 0; //Muestra actual (son 16)
reg [3:0] bitpos = 0; //Bit actual
reg [7:0] scratch = 8'b0; //Variable temporal para guardar la salida cuando se va recibiendo

always @(posedge clk_50m) begin
	if (rdy_clr)//Se limpia la bandera si existe un rdy_clr
		rdy <= 0;

	if (clken) begin
		case (state)
		RX_STATE_START: begin
			/*
			* Start counting from the first low sample, once we've
			* sampled a full bit, start collecting data bits.
			*/
			if (!rx || sample != 0)//Cuando la senial sea 0 el protocolo inicia, se empieza a contar segun el clock de 16 muestras a 115200 bauds
				sample <= sample + 4'b1;

			if (sample == 15) begin//Se llega a la ultima muestra del primer bit
				state <= RX_STATE_DATA;//Pasa al siguiente estado
				bitpos <= 0;//Primer bit
				sample <= 0;//Primera muestra
				scratch <= 0;//Temp vacia
			end
		end
		RX_STATE_DATA: begin
			sample <= sample + 4'b1;//Cada vez que haya flanco del reloj reducido por 16, cuenta una muestra
			if (sample == 4'h8) begin//En la octava muestra
				scratch[bitpos[2:0]] <= rx;//Segun el bit en el que se vaya, se guarda el resultado hasta ahora
				bitpos <= bitpos + 4'b1;//Se pasa a la siguiente posicion de bit
			end
			if (bitpos == 8 && sample == 9 ) //Cuando se llega al ultimo bit, finalizando el muestreo, termina el protocolo
				state <= RX_STATE_STOP;
		end
		RX_STATE_STOP: begin
			/*
			 * Our baud clock may not be running at exactly the
			 * same rate as the transmitter.  If we thing that
			 * we're at least half way into the stop bit, allow
			 * transition into handling the next start bit.
			 */
			if (sample == 15 || (sample >= 1 && rx)) begin //Reiniciamos la maquina y avisamos que el byte esta listo
				state <= RX_STATE_START;
				data <= scratch;
				rdy <= 1'b1;
				sample <= 0;
			end else begin
				sample <= sample + 4'b1;
			end
		end
		default: begin
			state <= RX_STATE_START;
		end
		endcase
	end
end

endmodule
