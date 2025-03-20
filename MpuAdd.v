
module MpuAdd (
    input wire [199:0] A,
	 input wire [199:0] B,
	 input wire [2:0] matrix_size,
    output wire [199:0] result     // 5x5 8-bits matrix
);

    genvar i;
	
		generate 
		
		for (i = 0; i < 25; i = i+1) begin : sum_loop
			assign result[i*8 +: 8] = (i < matrix_size * matrix_size) ? (A[i*8 +:8] + B[i*8 +: 8]) : 8'b0;
			end
			endgenerate
	 
	 
	 endmodule