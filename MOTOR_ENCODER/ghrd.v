// ============================================================================
// Copyright (c) 2014 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Tue Dec  2 09:28:38 2014
// ============================================================================

`define ENABLE_HPS
//`define ENABLE_CLK

module ghrd(

      ///////// ADC /////////
      output             ADC_CONVST,
      output             ADC_SCK,
      output             ADC_SDI,
      input              ADC_SDO,

      ///////// ARDUINO /////////
      inout       [15:0] ARDUINO_IO,
      inout              ARDUINO_RESET_N,

`ifdef ENABLE_CLK
      ///////// CLK /////////
      output             CLK_I2C_SCL,
      inout              CLK_I2C_SDA,
`endif /*ENABLE_CLK*/

      ///////// FPGA /////////
      input              FPGA_CLK1_50,
      input              FPGA_CLK2_50,
      input              FPGA_CLK3_50,

      ///////// GPIO /////////
      inout       [35:0] GPIO_0,
      inout       [35:0] GPIO_1,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C0_SCLK,
      inout              HPS_I2C0_SDAT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// KEY /////////
      input       [1:0]  KEY,

      ///////// LED /////////
      output      [7:0]  LED,

      ///////// SW /////////
      input       [3:0]  SW
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
  wire  hps_fpga_reset_n;
  wire [1:0] fpga_debounced_buttons;
  wire [6:0]  fpga_led_internal;
  wire [2:0]  hps_reset_req;
  wire        hps_cold_reset;
  wire        hps_warm_reset;
  wire        hps_debug_reset;
  wire [27:0] stm_hw_events;
  wire 		  fpga_clk_50;
// connection of internal logics
  assign LED[7:1] = fpga_led_internal;
  assign fpga_clk_50=FPGA_CLK1_50;
  assign stm_hw_events    = {{15{1'b0}}, SW, fpga_led_internal, fpga_debounced_buttons};
  
  // ROBOCOL CONNECTIONS
  wire [27:0]	count;		// Prescaler value.
  wire			CLK_scaled; // Output clock.
  wire [7:0]	PWM_DATA_1, PWM_DATA_2, PWM_DATA_3, PWM_DATA_4, PWM_DATA_5, PWM_DATA_6;
  wire [7:0]	PWM_DATA;
  // i2c connection
  wire scl_o_e;
  wire scl_o;
  wire sda_o_e;
  wire sda_o; 
  
//=======================================================
//  Structural coding
//=======================================================
// Prescaller
Prescaller prescaller_0(!KEY[0], FPGA_CLK1_50, CLK_scaled, count);
assign GPIO_0[0] = CLK_scaled;
// PWM generators (control signal generation with PWM)
assign ARDUINO_IO[2]=0;
assign ARDUINO_IO[4]=1;
assign ARDUINO_IO[6]=1;
assign ARDUINO_IO[7]=0;
assign ARDUINO_IO[8]=0;
assign ARDUINO_IO[10]=0;
assign ARDUINO_IO[12]=0;

//PWM_Generator PWM_1(!KEY[0], FPGA_CLK1_50, PWM_DATA_1, ARDUINO_IO[9]);
//PWM_Generator PWM_2(!KEY[0], FPGA_CLK1_50, PWM_DATA_2, GPIO_0[2]);
//PWM_Generator PWM_3(!KEY[0], FPGA_CLK1_50, PWM_DATA, GPIO_0[3]);
//PWM_Generator PWM_4(!KEY[0], FPGA_CLK1_50, PWM_DATA, GPIO_0[4]);
//PWM_Generator PWM_5(!KEY[0], FPGA_CLK1_50, PWM_DATA, GPIO_0[5]);
//PWM_Generator PWM_6(!KEY[0], FPGA_CLK1_50, PWM_DATA, GPIO_0[6]);

ALT_IOBUF scl_iobuf (.i(1'b0), .oe(scl_o_e), .o(scl_o), .io(GPIO_1[0])); //declared bi-directional buffer for scl
ALT_IOBUF sda_iobuf (.i(1'b0), .oe(sda_o_e), .o(sda_o), .io(GPIO_1[1])); //declared bi-directional buffer for sda

// ENCODERS
// DEBOUNCERS ENCODERS //
wire DB1_A, DB1_B, DB2_A, DB2_B, DB3_A, DB3_B, DB4_A, DB4_B, DB5_A, DB5_B, DB6_A, DB6_B;
// MOTOR 1
DeBounce1 DB1_MA(FPGA_CLK1_50, !KEY[0], GPIO_0[8] ,DB1_A);
DeBounce1 DB1_MB(FPGA_CLK1_50, !KEY[0], GPIO_0[9] ,DB1_B);
// Wires for enconder counts
wire signed [31:0] Count1, Count2, Count3, Count4, Count5, Count6;
// Encoders counter (Total encoder counts)
Encoder Encoder1(FPGA_CLK1_50, DB1_A, DB1_B, Count1);

wire [5:0] PWM;

assign PWM[0] =  ARDUINO_IO[9];

 soc_system u0 (
		//Clock&Reset
	  .clk_clk                               (FPGA_CLK1_50 ),				//	clk.clk
	  .reset_reset_n                         (hps_fpga_reset_n ),			//	reset.reset_n
	  //HPS ddr3
	  .memory_mem_a                          ( HPS_DDR3_ADDR),				//	memory.mem_a
	  .memory_mem_ba                         ( HPS_DDR3_BA),					//	.mem_ba
	  .memory_mem_ck                         ( HPS_DDR3_CK_P),				//	.mem_ck
	  .memory_mem_ck_n                       ( HPS_DDR3_CK_N),				//	.mem_ck_n
	  .memory_mem_cke                        ( HPS_DDR3_CKE),				//	.mem_cke
	  .memory_mem_cs_n                       ( HPS_DDR3_CS_N),				//	.mem_cs_n
	  .memory_mem_ras_n                      ( HPS_DDR3_RAS_N),				//	.mem_ras_n
	  .memory_mem_cas_n                      ( HPS_DDR3_CAS_N),				//	.mem_cas_n
	  .memory_mem_we_n                       ( HPS_DDR3_WE_N),				//	.mem_we_n
	  .memory_mem_reset_n                    ( HPS_DDR3_RESET_N),			//	.mem_reset_n
	  .memory_mem_dq                         ( HPS_DDR3_DQ),					//	.mem_dq
	  .memory_mem_dqs                        ( HPS_DDR3_DQS_P),				//	.mem_dqs
	  .memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),				//	.mem_dqs_n
	  .memory_mem_odt                        ( HPS_DDR3_ODT),				//	.mem_odt
	  .memory_mem_dm                         ( HPS_DDR3_DM),					//	.mem_dm
	  .memory_oct_rzqin                      ( HPS_DDR3_RZQ),				//	.oct_rzqin                                  
	  //HPS ethernet		
	  .hps_0_hps_io_hps_io_emac1_inst_TX_CLK ( HPS_ENET_GTX_CLK),       	//	hps_0_hps_io.hps_io_emac1_inst_TX_CLK
	  .hps_0_hps_io_hps_io_emac1_inst_TXD0   ( HPS_ENET_TX_DATA[0] ),   	//	.hps_io_emac1_inst_TXD0
	  .hps_0_hps_io_hps_io_emac1_inst_TXD1   ( HPS_ENET_TX_DATA[1] ),   	//	.hps_io_emac1_inst_TXD1
	  .hps_0_hps_io_hps_io_emac1_inst_TXD2   ( HPS_ENET_TX_DATA[2] ),   	//	.hps_io_emac1_inst_TXD2
	  .hps_0_hps_io_hps_io_emac1_inst_TXD3   ( HPS_ENET_TX_DATA[3] ),   	//	.hps_io_emac1_inst_TXD3
	  .hps_0_hps_io_hps_io_emac1_inst_RXD0   ( HPS_ENET_RX_DATA[0] ),   	//	.hps_io_emac1_inst_RXD0
	  .hps_0_hps_io_hps_io_emac1_inst_MDIO   ( HPS_ENET_MDIO ),         	//	.hps_io_emac1_inst_MDIO
	  .hps_0_hps_io_hps_io_emac1_inst_MDC    ( HPS_ENET_MDC  ),         	//	.hps_io_emac1_inst_MDC
	  .hps_0_hps_io_hps_io_emac1_inst_RX_CTL ( HPS_ENET_RX_DV),         	//	.hps_io_emac1_inst_RX_CTL
	  .hps_0_hps_io_hps_io_emac1_inst_TX_CTL ( HPS_ENET_TX_EN),         	//	.hps_io_emac1_inst_TX_CTL
	  .hps_0_hps_io_hps_io_emac1_inst_RX_CLK ( HPS_ENET_RX_CLK),        	//	.hps_io_emac1_inst_RX_CLK
	  .hps_0_hps_io_hps_io_emac1_inst_RXD1   ( HPS_ENET_RX_DATA[1] ),   	//	.hps_io_emac1_inst_RXD1
	  .hps_0_hps_io_hps_io_emac1_inst_RXD2   ( HPS_ENET_RX_DATA[2] ),   	//	.hps_io_emac1_inst_RXD2
	  .hps_0_hps_io_hps_io_emac1_inst_RXD3   ( HPS_ENET_RX_DATA[3] ),		//	.hps_io_emac1_inst_RXD3		  
	  //HPS SD card
	  .hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),				//	.hps_io_sdio_inst_CMD
	  .hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ),		//	.hps_io_sdio_inst_D0
	  .hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ),		//	.hps_io_sdio_inst_D1
	  .hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),				//	.hps_io_sdio_inst_CLK
	  .hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),		//	.hps_io_sdio_inst_D2
	  .hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),		//	.hps_io_sdio_inst_D3
	  //HPS USB
	  .hps_0_hps_io_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),		//	.hps_io_usb1_inst_D0
	  .hps_0_hps_io_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),		//	.hps_io_usb1_inst_D1
	  .hps_0_hps_io_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),		//	.hps_io_usb1_inst_D2
	  .hps_0_hps_io_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),		//	.hps_io_usb1_inst_D3
	  .hps_0_hps_io_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),		//	.hps_io_usb1_inst_D4
	  .hps_0_hps_io_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),		//	.hps_io_usb1_inst_D5
	  .hps_0_hps_io_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),		//	.hps_io_usb1_inst_D6
	  .hps_0_hps_io_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),		//	.hps_io_usb1_inst_D7
	  .hps_0_hps_io_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ),		//	.hps_io_usb1_inst_CLK
	  .hps_0_hps_io_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),			//	.hps_io_usb1_inst_STP
	  .hps_0_hps_io_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),			//	.hps_io_usb1_inst_DIR
	  .hps_0_hps_io_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),			//	.hps_io_usb1_inst_NXT
		//HPS SPI 		  
	  .hps_0_hps_io_hps_io_spim1_inst_CLK    ( HPS_SPIM_CLK  ),				//	.hps_io_spim1_inst_CLK
	  .hps_0_hps_io_hps_io_spim1_inst_MOSI   ( HPS_SPIM_MOSI ),				//	.hps_io_spim1_inst_MOSI
	  .hps_0_hps_io_hps_io_spim1_inst_MISO   ( HPS_SPIM_MISO ),				//	.hps_io_spim1_inst_MISO
	  .hps_0_hps_io_hps_io_spim1_inst_SS0    ( HPS_SPIM_SS   ),				//	.hps_io_spim1_inst_SS0
		//HPS UART		
	  .hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX   ),          //	.hps_io_uart0_inst_RX
	  .hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX   ),          //	.hps_io_uart0_inst_TX
		//HPS I2C1
	  .hps_0_hps_io_hps_io_i2c0_inst_SDA     ( HPS_I2C0_SDAT  ),			//	.hps_io_i2c0_inst_SDA
	  .hps_0_hps_io_hps_io_i2c0_inst_SCL     ( HPS_I2C0_SCLK  ),			//	.hps_io_i2c0_inst_SCL
		//HPS I2C2
	  .hps_0_hps_io_hps_io_i2c1_inst_SDA     ( HPS_I2C1_SDAT  ),			//	.hps_io_i2c1_inst_SDA
	  .hps_0_hps_io_hps_io_i2c1_inst_SCL     ( HPS_I2C1_SCLK  ),			//	.hps_io_i2c1_inst_SCL
		//GPIO 
	  .hps_0_hps_io_hps_io_gpio_inst_GPIO09  ( HPS_CONV_USB_N ),			//	.hps_io_gpio_inst_GPIO09
	  .hps_0_hps_io_hps_io_gpio_inst_GPIO35  ( HPS_ENET_INT_N ),			//	.hps_io_gpio_inst_GPIO35
	  .hps_0_hps_io_hps_io_gpio_inst_GPIO40  ( HPS_LTC_GPIO   ),			//	.hps_io_gpio_inst_GPIO40
	  .hps_0_hps_io_hps_io_gpio_inst_GPIO53  ( HPS_LED   ),					//	.hps_io_gpio_inst_GPIO53
	  .hps_0_hps_io_hps_io_gpio_inst_GPIO54  ( HPS_KEY   ),					//	.hps_io_gpio_inst_GPIO54
	  .hps_0_hps_io_hps_io_gpio_inst_GPIO61  ( HPS_GSENSOR_INT ),			//	.hps_io_gpio_inst_GPIO61
		//FPGA Partion
	  .custom_leds_0_leds_new_signal    ( fpga_led_internal 	),				//	led_pio_external_connection.export
	  .dipsw_pio_external_connection_export  ( SW	),							//	dipsw_pio_external_connection.export
	  .button_pio_external_connection_export ( fpga_debounced_buttons	),	//	button_pio_external_connection.export
	  
	  .hps_0_h2f_reset_reset_n               ( hps_fpga_reset_n ),			//	hps_0_h2f_reset.reset_n
	  .hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset ),			//	hps_0_f2h_cold_reset_req.reset_n
     .hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset ),			//	hps_0_f2h_debug_reset_req.reset_n
     .hps_0_f2h_stm_hw_events_stm_hwevents  (stm_hw_events ),				//	hps_0_f2h_stm_hw_events.stm_hwevents
     .hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset ),			//	hps_0_f2h_warm_reset_req.reset_n
	  
	  .custom_prescaller_0_prescaller_new_signal (count),						// custom_prescaller_0_prescaller.new_signal
	  
	  //.custom_pwm_0_pwm_out_new_signal           (PWM_DATA_1),				//	custom_pwm_0_pwm_out.new_signal
	  //.custom_pwm_1_pwm_out_new_signal           (PWM_DATA_2),				//	custom_pwm_1_pwm_out.new_signal
	  
	  // I2C interface from HPS export to FPGA
	  //.hps_0_i2c2_scl_in_clk                     (scl_o),						//	hps_0_i2c2_scl_in.clk
	  //.hps_0_i2c2_clk_clk                        (scl_o_e),					//	hps_0_i2c2_clk.clk
	  //.hps_0_i2c2_out_data                       (sda_o_e),					//	hps_0_i2c2.out_data
	  //.hps_0_i2c2_sda                            (sda_o),						//	.sda
	  
	  // Prescaller count test
	  //.count_0_external_connection_export        (Count1),					//	count_0_external_connection.export
	  .custom_count_0_count_new_signal           (Count1),					//	custom_count_0_count.new_signal
	  
	  .pwm_avalon_bridge_0_conduit_end_new_signal       (PWM)				//	pwm_bridge_0_conduit_end.new_signal
 );
 
 //pwm_avalon_bridge #(
//		.NUMBER_OF_MOTORS (2),
//		.CLOCK_SPEED_HZ   (50000000),
//		.PWM_FREQ         (20000),
//		.PWM_PAUSE_FREQ   (20000),
//		.PWM_RESOLUTION   (8),
//		.PWM_PHASES       (1)
//	) pwm_0 (
//		.reset     (rst_controller_reset_out_reset),                   //	reset.reset
//		.address   (mm_interconnect_0_pwm_0_avalon_slave_0_address),   //	avalon_slave_0.address
//		.write     (mm_interconnect_0_pwm_0_avalon_slave_0_write),     //	.write
//		.writedata (mm_interconnect_0_pwm_0_avalon_slave_0_writedata), //	.writedata
//		.PWM       (pwm_0_conduit_end_pwm),                            //	conduit_end.pwm
//		.clock     (clk_clk)                                           //	clock_sink.clk
//	);

// Debounce logic to clean out glitches within 1ms
debounce debounce_inst (
  .clk                                  (fpga_clk_50),
  .reset_n                              (hps_fpga_reset_n),  
  .data_in                              (KEY),
  .data_out                             (fpga_debounced_buttons)
);
  defparam debounce_inst.WIDTH = 2;
  defparam debounce_inst.POLARITY = "LOW";
  defparam debounce_inst.TIMEOUT = 50000;               // at 50Mhz this is a debounce time of 1ms
  defparam debounce_inst.TIMEOUT_WIDTH = 16;            // ceil(log2(TIMEOUT))
  
// Source/Probe megawizard instance
hps_reset hps_reset_inst (
  .source_clk (fpga_clk_50),
  .source     (hps_reset_req)
);

altera_edge_detector pulse_cold_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[0]),
  .pulse_out (hps_cold_reset)
);
  defparam pulse_cold_reset.PULSE_EXT = 6;
  defparam pulse_cold_reset.EDGE_TYPE = 1;
  defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[1]),
  .pulse_out (hps_warm_reset)
);
  defparam pulse_warm_reset.PULSE_EXT = 2;
  defparam pulse_warm_reset.EDGE_TYPE = 1;
  defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;
  
altera_edge_detector pulse_debug_reset (
  .clk       (fpga_clk_50),
  .rst_n     (hps_fpga_reset_n),
  .signal_in (hps_reset_req[2]),
  .pulse_out (hps_debug_reset)
);
  defparam pulse_debug_reset.PULSE_EXT = 32;
  defparam pulse_debug_reset.EDGE_TYPE = 1;
  defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;

reg [25:0] counter; 
reg  led_level;
always @	(posedge fpga_clk_50 or negedge hps_fpga_reset_n)
begin
if(~hps_fpga_reset_n)
begin
		counter<=0;
		led_level<=0;
end

else if(counter==24999999)
	begin
		counter<=0;
		led_level<=~led_level;
	end
else
		counter<=counter+1'b1;
end

assign LED[0]=led_level;
endmodule
