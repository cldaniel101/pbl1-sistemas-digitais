

module Teste (input Clock, input button, output LED_0, output LED_1);
    reg [199:0] Matrix_A ; // 5x5 8-bit matrix (flattened)
    reg [199:0] Matrix_B ; // 5x5 8-bit matrix (flattened)
    reg [199:0] Data_in; 
    reg wren; 
    reg [2:0] Adress; 
	 reg [0:7] state;
    wire [199:0] Data_out; 
    wire [199:0] Result; // 5x5 result matrix (flattened)

    // Instanciação do módulo Teste_Read
		 
		Teste_memory memory(
			Adress,
			Clock,
			Data_in,
			wren,
			Data_out);
    
    // Instanciação do módulo MpuAdd para somar Matrix_A e Matrix_B
    MpuAdd mpu_add (
        Matrix_A, 
        Matrix_B, 
		  2,
        Result // A matriz resultante será armazenada aqui
    );
	 
	 debounce botao (
		button,
		Clock,
		B_button
		);
	 
	 and (c,Clock, B_button);

      always @(posedge B_button) begin
        case (state)
            3'b000: begin
                wren = 0;
                Matrix_A = Data_out; // Atribui valor em Matrix_A baseado no endereço
                state = state + 1; 
            end
            3'b001: begin
                wren = 0;
                Matrix_A = Data_out; // Atribui valor em Matrix_A baseado no endereço
					 Adress = Adress + 1;
                state = state + 1; 
            end
            3'b010: begin
                wren = 0;
                Matrix_B = Data_out; // Atribui valor em Matrix_A baseado no endereço
                state = state + 1;
            end
            3'b011: begin
                wren = 0;
                Matrix_B = Data_out; // Atribui valor em Matrix_A baseado no endereço
					 Adress = Adress + 1;
                state = state + 1;
            end
				3'b100: begin
					wren = 1;
					state = state + 1; 
				end
				3'b101: begin
					Data_in = Result;
					wren = 1;
					state = state + 1; 
				end
				3'b110: begin
					Data_in = Result;
					wren = 1;
					state = state + 1; 
				end
				3'b111: begin
					Data_in = Result;
					wren = 0;
					Adress = 2'b00;
					state = 3'b000; 
				end
        endcase
    end
	 
	 	assign LED_0 = Matrix_B[0];
		assign LED_1 = Matrix_B[1];
	 
endmodule
