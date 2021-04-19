// (C) 2001-2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $File: //acds/rel/19.1std/ip/sopc/components/verification/altera_avalon_reset_source/altera_avalon_reset_source.sv $
// $Revision: #1 $
// $Date: 2018/11/07 $
// $Author: psgswbuild $
//------------------------------------------------------------------------------
// Reset generator

`timescale 1ps / 1ps

module altera_avalon_reset_source (
				   clk,
				   reset
				   );
   input  clk;
   output reset;

   parameter ASSERT_HIGH_RESET = 1;    // reset assertion level is high by default
   parameter INITIAL_RESET_CYCLES = 0; // deassert after number of clk cycles
   
// synthesis translate_off
   import verbosity_pkg::*;
   
   logic reset    = ASSERT_HIGH_RESET ? 1'b0 : 1'b1; 
  
   string message = "*uninitialized*";

   int 	  clk_ctr = 0;
   
   always @(posedge clk) begin
      clk_ctr <= clk_ctr + 1;
   end

   always @(*) 
     if (clk_ctr == INITIAL_RESET_CYCLES)
       reset_deassert();

   
   function automatic void __hello();
      $sformat(message, "%m: - Hello from altera_reset_source");
      print(VERBOSITY_INFO, message);            
      $sformat(message, "%m: -   $Revision: #1 $");
      print(VERBOSITY_INFO, message);            
      $sformat(message, "%m: -   $Date: 2018/11/07 $");
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   ASSERT_HIGH_RESET = %0d", ASSERT_HIGH_RESET);      
      print(VERBOSITY_INFO, message);
      $sformat(message, "%m: -   INITIAL_RESET_CYCLES = %0d", INITIAL_RESET_CYCLES);      
      print(VERBOSITY_INFO, message);      
      print_divider(VERBOSITY_INFO);      
   endfunction

   function automatic string get_version();  // public
      // Return BFM version as a string of three integers separated by periods.
      // For example, version 9.1 sp1 is encoded as "9.1.1".      
      string ret_version = "19.1";
      return ret_version;
   endfunction
   
   task automatic reset_assert();  // public
      $sformat(message, "%m: Reset asserted");
      print(VERBOSITY_INFO, message);       
     
      if (ASSERT_HIGH_RESET > 0) begin
	 reset = 1'b1;
      end else begin
	 reset = 1'b0;
      end
   endtask

   task automatic reset_deassert();  // public
      $sformat(message, "%m: Reset deasserted");
      print(VERBOSITY_INFO, message);       
      
      if (ASSERT_HIGH_RESET > 0) begin      
	 reset = 1'b0;
      end else begin
	 reset = 1'b1;
      end
   endtask
   
   initial begin
      __hello();
      if (INITIAL_RESET_CYCLES > 0) 
	reset_assert();
   end
// synthesis translate_on

endmodule

