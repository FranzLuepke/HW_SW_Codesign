//MODULO PRINCIPAL DE LA TRANSMISION UART, SOLO SE USA LA RECEPCION
module uart(input wire [7:0] din,
	    input wire wr_en,
	    input wire clk_50m,
	    output wire tx,
	    output wire tx_busy,
	    input wire rx,
	    output wire rdy,
	    input wire rdy_clr,
	    output wire [7:0] dout);//Las conexiones sin utilizar se muestran en el modulo principal

wire rxclk_en, txclk_en;

//Genera un clock mas lento, que es utilizado para sincronizar la recepcion de datos
baud_rate_gen uart_baud(.clk_50m(clk_50m),
			.rxclk_en(rxclk_en),
			.txclk_en(txclk_en));

//En desuso
transmitter uart_tx(.din(din),
		    .wr_en(wr_en),
		    .clk_50m(clk_50m),
		    .clken(txclk_en),
		    .tx(tx),
		    .tx_busy(tx_busy));

//Recibe datos segun el protocolo UART a 115200 bauds
receiver uart_rx(.rx(rx),
		 .rdy(rdy),
		 .rdy_clr(rdy_clr),
		 .clk_50m(clk_50m),
		 .clken(rxclk_en),
		 .data(dout));

endmodule
