module Teste_Write (input clock ,input [7:0] Data_input, output [7:0] Data);
	
	Teste_memory(
		2'b01,
		clock,
		Data_input,
		1'b1,
	);



endmodule