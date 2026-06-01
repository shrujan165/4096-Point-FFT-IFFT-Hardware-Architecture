module pe_stage3( 
    input logic clk,
    input logic rst,
    input  logic signed [15:0] x_stage3 [0:15][0:1], 
    output logic signed [15:0] X_stage3 [0:15][0:1] 
);

    bs16_complex bs_inst (
        .clk(clk),
        .x(x_stage3),
        .X(X_stage3)
    );

endmodule