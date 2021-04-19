//Declaracion generica de un MUX
module mux(din0, din1, sel, out);

input din0, din1, sel;
output out;

wire out;

assign out = (sel) ? din1 : din0;

endmodule
