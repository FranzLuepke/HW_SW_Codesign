module TimerEspera(clk, start, done);

	input clk;
	input start;
	output done;
	
//=======================================================
//  REG/WIRE declarations
//=======================================================
	reg [30:0] St_Register;
	reg [30:0] St_Signal;
	reg St_done = 1'b0;

//=======================================================
//  Structural coding
//=======================================================
//-------INPUT LOGIC: COMBINATIONAL-----------------------------//
// NEXT STATE LOGIC : COMBINATIONAL
  //Este always se encarga de contar en cada flanco del reloj del módulo siempre que FR_TIMER_COUNTER_Enable este activa.
  //Además, se encarga de reiniciar el temporizador una vez llegue a 3'b100.
  always @ (*)
		begin
			if (start == 1'b1)
			begin
				if(St_Register == 30'd10000000)
					St_Signal = 0;
				else
					St_Signal = St_Register + 1;
			end
			else 
				St_Signal = St_Register;
		 end
	
//-----------------------SEQUENTIAL----------------------------//
	//Este always se encarga de actualizar el temporizador en cada flanco de reloj y reiniciarlo si llega a 3'b100 o si se activa la señal FR_TIMER_COUNTER_Reset.
	always @ ( posedge clk)
	begin
		if(St_Register == 30'd10000000)
		begin
			St_Register <= 0;
			St_done <= 1'b1;
		end
		else
		begin
			St_Register <= St_Signal;
			St_done <= 1'b0;
		end
	end
//=======================================================
//  Outputs
//=======================================================
//-----------OUTPUT LOGIC : COMBINATIONAL -------------------------
assign done = St_done;
endmodule