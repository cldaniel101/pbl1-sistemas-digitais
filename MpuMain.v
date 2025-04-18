 

module MpuMain (
	input button, 
	input [2:0] ops,
	input clock,
	input size2_lever, 
	
	output LED_0, 
	output LED_1, 
	output LED_2
);

    reg [199:0] Matrix_A ; // 5x5 8-bit matrix (flattened)
    reg [199:0] Matrix_B ; // 5x5 8-bit matrix (flattened)
    reg [199:0] Data_in;
    reg wren; 	// Write Enable
    reg [1:0] count; 	 
    reg [2:0] Adress; 	   // Address to I/O 
	 reg [7:0] state;	   // Current State of the MPU
    wire [199:0] Data_out;
    wire [199:0] Result;   // 5x5 result matrix (flattened)
		 
	MemoryIO memory(
		Adress,
		clock,
		Data_in,
		wren,
		Data_out
	);
    
	 MpuOperations op(
		ops,
		Matrix_A,
		Matrix_B,
		(size2_lever)? 8'd2 : 8'd3,
		Matrix_B[0 +: 8],

		clock,

    	Result
	);
	 
	 Debounce botao (
		button,
		clock,
	
		B_button
	);
	Clock_divider new_clock (
		clock,
		clock_out
		);
	 
    always @(posedge clock_out) begin
        case (state)
		3'b000: begin
			wren = 0;
			Matrix_A = Data_out; // Atribui valor em Matrix_A baseado no endereço
			if (B_button)
				state = state + 1 ;
		end
		3'b001: begin
			wren = 0;
			Matrix_A = Data_out; // Atribui valor em Matrix_A baseado no endereço
			Adress = Adress + 1;
			state = state + 1 ;
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
			
			if (count != 3) begin
			count = count + 1;
			end
			else
			begin 
			state = state + 1;
			count = 0;
			end
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
	 
	assign LED_0 = state[0];
	assign LED_1 = state[1];
	assign LED_2 = state[2];
	 
endmodule