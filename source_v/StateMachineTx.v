
module StateMachineTX (clk, msj_Done, Tx_Done, Timer_Done, SH_Done, Start_Tx, Start_msj, Start_SH, Start_Timer);
	
	parameter St_Count0 = 3'b000; 
	parameter St_Count1 = 3'b001;
	parameter St_Count2 = 3'b010;
	parameter St_Count3 = 3'b011;
	parameter St_Count4 = 3'b100;
	parameter St_Count5 = 3'b101;
	parameter St_Count6 = 3'b110;
	parameter St_Count7 = 3'b111;

	input clk;
	input msj_Done;
	input Tx_Done;
	input Timer_Done;
	input SH_Done;
	
	output reg Start_Tx;
	output reg Start_msj;
	output reg Start_SH;
	output reg Start_Timer;
	

	reg [3:0] St_Register;
	reg [3:0] St_Signal;
	
always @(*)
		case (St_Register)
			
			St_Count0: 

					if(Tx_Done == 1'b0)
						St_Signal = St_Count1;
					else
						St_Signal = St_Count0;

			St_Count1:	

					St_Signal = St_Count2;
							
			St_Count2:  

					if(msj_Done == 1'b1)
						St_Signal = St_Count3;
					else
						St_Signal = St_Count2;
			
			St_Count3:

					if(Timer_Done ==1'b1)
						St_Signal = St_Count4;
					else
						St_Signal = St_Count3;

			St_Count4:

					if(Tx_Done == 1'b0)
						St_Signal = St_Count5;
					else
						St_Signal = St_Count4;
			
			St_Count5:

							St_Signal = St_Count6;
			
			St_Count6:

					if(SH_Done == 1'b1)
						St_Signal = St_Count7;
					else
						St_Signal = St_Count4;
			
			St_Count7:

							St_Signal = St_Count0;
							
			default: St_Signal = St_Signal;
			
		endcase
always @ (posedge clk)
	St_Register <= St_Signal;

always @ (*)
		case (St_Register)
			St_Count0:
				begin
					Start_Tx = 1'b0;
					Start_msj = 1'b0;
					Start_SH = 1'b0;
					Start_Timer = 1'b0;
				end
			St_Count1:
				begin
					Start_Tx = 1'b0;
					Start_msj = 1'b1;
					Start_SH = 1'b0;
					Start_Timer = 1'b0;
				end
			St_Count2:
				begin
					Start_Tx = 1'b0;
					Start_msj = 1'b0;
					Start_SH = 1'b0;
					Start_Timer = 1'b0;
				end
							
			St_Count3:
				begin
					Start_Tx = 1'b0;
					Start_msj = 1'b0;
					Start_SH = 1'b0;
					Start_Timer = 1'b1;
				end
			St_Count4:
				begin
					Start_Tx = 1'b1;
					Start_msj = 1'b0;
					Start_SH = 1'b0;
					Start_Timer = 1'b0;
				end
			St_Count5:
				begin
					Start_Tx = 1'b0;
					Start_msj = 1'b0;
					Start_SH = 1'b1;
					Start_Timer = 1'b0;
				end
			St_Count6:
				begin
					Start_Tx = 1'b0;
					Start_msj = 1'b0;
					Start_SH = 1'b0;
					Start_Timer = 1'b0;
				end
			St_Count7:
				begin
					Start_Tx = 1'b1;
					Start_msj = 1'b0;
					Start_SH = 1'b0;
					Start_Timer = 1'b0;
				end
				
			default: 
				begin
					Start_Tx = 1'b0;
					Start_msj = 1'b0;
					Start_SH = 1'b0;
					Start_Timer = 1'b0;
				end
			
		endcase
 
endmodule
 
		