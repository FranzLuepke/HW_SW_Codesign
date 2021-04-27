module avalon_rpm (clk, reset, address, read, readdata, waitrequest, rpm);

input clk;
input reset;
// this is for the avalon interface
input address;
input read;
output signed [31:0] readdata;
output waitrequest;
output signed [15:0] rpm;

reg waitFlag;
reg [31:0] returnvalue;
assign readdata = returnvalue;
assign waitrequest = (waitFlag && read);

always @(posedge clk, posedge reset) begin: AVALON_READ_INTERFACE
	if (reset == 1)
	begin
		waitFlag <= 1;
	end
	else
	begin
		waitFlag <= 1;
		if(read)
		begin
			case(address)
				1'b0:		returnvalue <= {16'b0,rpm[15:0]};
				default: returnvalue <= 32'b0;
			endcase
			if(waitFlag==1)
			begin // next clock cycle the returnvalue should be ready
				waitFlag <= 0;
			end
		end
	end
end


endmodule
