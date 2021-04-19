module A2Bin(A2, Bin, signo);
	input [15:0] A2;
	output reg [15:0] Bin;
	output reg signo;


	
always@(*)
begin

	case (A2[8])
		1'b0: //Positivo
		begin
			Bin = A2;
			signo = 1'b1;
		end
		1'b1: //Negativo
		begin
			Bin = ~A2 + 1'b1;
			signo = 1'b0;
		end
	endcase
	
	
end
	

	
endmodule
