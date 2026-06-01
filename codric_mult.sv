module cordic_stage
#(
parameter SHIFT = 0,
parameter signed [15:0] ANGLE = 0
)
(
input clk,

input signed [15:0] x_in,
input signed [15:0] y_in,
input signed [15:0] z_in,

output reg signed [15:0] x_out,
output reg signed [15:0] y_out,
output reg signed [15:0] z_out
);

wire direction;
assign direction = z_in[15];   // sign bit

wire signed [15:0] x_shift;
wire signed [15:0] y_shift;

assign x_shift = x_in >>> SHIFT;
assign y_shift = y_in >>> SHIFT;

always @(posedge clk)
begin

if(direction == 0)
begin
    x_out <= x_in - y_shift;
    y_out <= y_in + x_shift;
    z_out <= z_in - ANGLE;
end
else
begin
    x_out <= x_in + y_shift;
    y_out <= y_in - x_shift;
    z_out <= z_in + ANGLE;
end

end

endmodule


module cordic_rotator_1(

input clk,

input signed [15:0] x_in,
input signed [15:0] y_in,
input signed [15:0] theta,

output signed [15:0] x_out,
output signed [15:0] y_out

);

wire signed [15:0] x[0:10];
wire signed [15:0] y[0:10];
wire signed [15:0] z[0:10];

assign x[0] = x_in;
assign y[0] = y_in;
assign z[0] = theta;

cordic_stage #(.SHIFT(0), .ANGLE(16'd8192)) s0(clk,x[0],y[0],z[0],x[1],y[1],z[1]);
cordic_stage #(.SHIFT(1), .ANGLE(16'd4836)) s1(clk,x[1],y[1],z[1],x[2],y[2],z[2]);
cordic_stage #(.SHIFT(2), .ANGLE(16'd2555))  s2(clk,x[2],y[2],z[2],x[3],y[3],z[3]);
cordic_stage #(.SHIFT(3), .ANGLE(16'd1297))  s3(clk,x[3],y[3],z[3],x[4],y[4],z[4]);
cordic_stage #(.SHIFT(4), .ANGLE(16'd651))  s4(clk,x[4],y[4],z[4],x[5],y[5],z[5]);
cordic_stage #(.SHIFT(5), .ANGLE(16'd325))  s5(clk,x[5],y[5],z[5],x[6],y[6],z[6]);
cordic_stage #(.SHIFT(6), .ANGLE(16'd162))   s6(clk,x[6],y[6],z[6],x[7],y[7],z[7]);
cordic_stage #(.SHIFT(7), .ANGLE(16'd81))   s7(clk,x[7],y[7],z[7],x[8],y[8],z[8]);
cordic_stage #(.SHIFT(8), .ANGLE(16'd40))   s8(clk,x[8],y[8],z[8],x[9],y[9],z[9]);
cordic_stage #(.SHIFT(9), .ANGLE(16'd20))    s9(clk,x[9],y[9],z[9],x[10],y[10],z[10]);

wire signed [30:0] x_temp = x[10] * 16'sd19947;
wire signed [30:0] y_temp = y[10] * 16'sd19947;
assign x_out = x_temp[30:15];
assign y_out = y_temp[30:15];

endmodule