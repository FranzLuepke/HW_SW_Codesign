//Declaracion generica de un MUX (2 bits a la salida)
module mux1a2(din0, din1, sel, out);

input sel;
input [1:0] din0, din1;
output [1:0] out;

wire [1:0] out;

assign out = (sel) ? din1 : din0;

endmodule
