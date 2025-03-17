`define i8(x) 8'sd``x                /// defined a 8-bit integer
`define MATRIX_5x5 (0):(8*25-1)     /// defines a 5x5 matrix flatted array indexes
`define at(col, row) (8 * (row + 5*col))    /// Access each 8-bit element in the 5x5 matrix

module MpuOpposite (
    input      [`MATRIX_5x5] matrix_a,  // 5x5 8-bits matrix
    output reg [`MATRIX_5x5] result     // 5x5 8-bits matrix
);

    genvar col, row;
    generate
        for (col = 0; col < 5; col = col + 1) begin : col_loop
            for (row = 0; row < 5; row = row + 1) begin : row_loop
                always @(*) begin
                    result[`at(col, row) +: 8] = -matrix_a[`at(col, row) +: 8];
                end
            end
        end
    endgenerate

endmodule



module test_MpuOpposite;

    reg  [`MATRIX_5x5] matrix_a;
    wire [`MATRIX_5x5] result;

    MpuOpposite opp_operation (
        .matrix_a(matrix_a),
        .result(result)
    );

    initial begin

        matrix_a = {`i8(2),  -`i8(1),  `i8(0),  `i8(4),  `i8(5), 
                    `i8(12),  `i8(7),  `i8(8),  `i8(9),  `i8(10), 
                    `i8(22), `i8(12), `i8(13), `i8(14), `i8(15), 
                    `i8(32), `i8(17), `i8(18), `i8(19), `i8(20), 
                    `i8(45), `i8(22), `i8(23), `i8(24), `i8(1)};

        $display("Matrix A (matrix_a):");
        display_matrix(matrix_a);
        #1;        
        $display("Result (matrix_c or result):");
        display_matrix(result);

        $finish;
    end

    task display_matrix;
        input [`MATRIX_5x5] matrix;
        integer i;
        begin
            for (i = 0; i < 5; i = i + 1) begin
                $display("%4d %4d %4d %4d %4d", 
                    $signed(matrix[`at(i, 0) +: 8]),
                    $signed(matrix[`at(i, 1) +: 8]),
                    $signed(matrix[`at(i, 2) +: 8]),
                    $signed(matrix[`at(i, 3) +: 8]),
                    $signed(matrix[`at(i, 4) +: 8]));
            end
        end
    endtask

endmodule
