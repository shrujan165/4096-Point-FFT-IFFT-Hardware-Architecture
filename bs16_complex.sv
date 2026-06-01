module bs4_complex (
    input  logic signed [15:0] x [0:3][0:1],
    output logic signed [15:0] X [0:3][0:1]
);

    logic signed [17:0] a_re, a_im;
    logic signed [17:0] b_re, b_im;
    logic signed [17:0] c_re, c_im;
    logic signed [17:0] d_re, d_im;

    always_comb begin
        a_re = x[0][0] + x[2][0];
        a_im = x[0][1] + x[2][1];    
        b_re = x[1][0] + x[3][0];
        b_im = x[1][1] + x[3][1];
        c_re = x[0][0] - x[2][0];
        c_im = x[0][1] - x[2][1];
        d_re = x[1][0] - x[3][0];
        d_im = x[1][1] - x[3][1];

        X[0][0] = (a_re + b_re) >>> 2;
        X[0][1] = (a_im + b_im) >>> 2;
        X[2][0] = (a_re - b_re) >>> 2;
        X[2][1] = (a_im - b_im) >>> 2;
        X[1][0] = (c_re + d_im) >>> 2;
        X[1][1] = (c_im - d_re) >>> 2;
        X[3][0] = (c_re - d_im) >>> 2;
        X[3][1] = (c_im + d_re) >>> 2;

    end
endmodule


module csd_multiplier(
    input signed [15:0] xi[0:1],input signed [15:0] tw[0:1],output signed [15:0]y[0:1]);
    
    logic signed [30:0] real_part; 
    logic signed [30:0] img_part;
    assign real_part = xi[0]*tw[0]-xi[1]*tw[1]; 
    assign img_part = xi[0]*tw[1]+xi[1]*tw[0];
    
    assign y[0] = real_part[30:15];
    assign y[1] = img_part[30:15];

endmodule

module bs16_complex(
    input logic signed [15:0] x[0:15][0:1],input logic clk,output logic signed [15:0] X[0:15][0:1]);

parameter signed [15:0] W160[0:1]={16'b0111_1111_1111_1111,16'b0000_0000_0000_0000};
parameter signed [15:0] W161[0:1]={16'b0111_0110_0100_0010,16'b1100_1111_0000_0100};

parameter signed [15:0] W162[0:1] ={16'b0101_1010_1000_0010,16'b1010_0101_0111_1110};

parameter signed [15:0]W163[0:1] ={16'b0011_0000_1111_1100,16'b1000_1001_1011_1110};

parameter signed [15:0] W164[0:1] ={16'b0000_0000_0000_0000,16'b1000_0000_0000_0000};

parameter signed [15:0] W166[0:1] ={16'b1010_0101_0111_1110,16'b1010_0101_0111_1110};

parameter signed [15:0] W169 [0:1]={16'b1000_1001_1011_1110,16'b0011_0000_1111_1100};

logic signed [15:0] x_stage1[0:3][0:3][0:1];

logic signed [15:0] X_stage1[0:3][0:3][0:1],X_stage1_reg[0:3][0:3][0:1];

logic signed [15:0] X_stage2[0:3][0:3][0:1],X_stage2_reg[0:3][0:3][0:1];

logic signed [15:0] x_stage2[0:3][0:3][0:1];

always_comb begin
    for(int i=0;i<4;i++) begin
        for(int j=0;j<4;j++) begin
            x_stage1[i][j][0] = x[j*4 +i][0];
            x_stage1[i][j][1] = x[j*4 +i][1];
        end
    end

end

always_comb begin
    for(int i=0;i<4;i++) begin
        for(int j=0;j<4;j++) begin
            X[i+j*4][0]=X_stage2_reg[i][j][0];
            X[i+j*4][1]=X_stage2_reg[i][j][1];

        end
    end
end

always_ff @(posedge clk) begin
    for(int i=0;i<4;i++) begin
        for(int j=0;j<4;j++) begin
            X_stage1_reg[i][j][0] <= X_stage1[i][j][0];
            X_stage1_reg[i][j][1] <= X_stage1[i][j][1];
            X_stage2_reg[i][j][0] <= X_stage2[i][j][0];
            X_stage2_reg[i][j][1] <= X_stage2[i][j][1];

        end
    end
end

logic signed [15:0] x_stage2_1proper [0:3][0:1];
logic signed [15:0] x_stage2_2proper [0:3][0:1];
logic signed [15:0] x_stage2_3proper [0:3][0:1];
logic signed [15:0] x_stage2_4proper [0:3][0:1];

always_comb begin

    x_stage2_1proper[0] = X_stage1_reg[0][0];
    x_stage2_1proper[1] = x_stage2[1][0];
    x_stage2_1proper[2] = x_stage2[2][0];
    x_stage2_1proper[3] = x_stage2[3][0];

    x_stage2_2proper[0] = X_stage1_reg[0][1];
    x_stage2_2proper[1] = x_stage2[1][1];
    x_stage2_2proper[2] = x_stage2[2][1];
    x_stage2_2proper[3] = x_stage2[3][1];

    x_stage2_3proper[0] = X_stage1_reg[0][2];
    x_stage2_3proper[1] = x_stage2[1][2];
    x_stage2_3proper[2] = x_stage2[2][2];
    x_stage2_3proper[3] = x_stage2[3][2];

    x_stage2_4proper[0] = X_stage1_reg[0][3];
    x_stage2_4proper[1] = x_stage2[1][3];
    x_stage2_4proper[2] = x_stage2[2][3];
    x_stage2_4proper[3] = x_stage2[3][3];
end

bs4_complex bs4_stage1_1(.x(x_stage1[0]),.X(X_stage1[0]));
bs4_complex bs4_stage1_2(.x(x_stage1[1]),.X(X_stage1[1]));
bs4_complex bs4_stage1_3(.x(x_stage1[2]),.X(X_stage1[2]));
bs4_complex bs4_stage1_4(.x(x_stage1[3]),.X(X_stage1[3]));

bs4_complex bs4_stage2_1(.x(x_stage2_1proper),.X(X_stage2[0]));
csd_multiplier csd0(.xi(X_stage1_reg[1][0]),.tw(W160),.y(x_stage2[1][0]));
csd_multiplier csd1(.xi(X_stage1_reg[1][1]),.tw(W161),.y(x_stage2[1][1]));
csd_multiplier csd2(.xi(X_stage1_reg[1][2]),.tw(W162),.y(x_stage2[1][2]));
csd_multiplier csd3(.xi(X_stage1_reg[1][3]),.tw(W163),.y(x_stage2[1][3]));

bs4_complex bs4_stage2_2(.x(x_stage2_2proper),.X(X_stage2[1]));

csd_multiplier csd4(.xi(X_stage1_reg[2][0]),.tw(W160),.y(x_stage2[2][0]));
csd_multiplier csd5(.xi(X_stage1_reg[2][1]),.tw(W162),.y(x_stage2[2][1]));
csd_multiplier csd6(.xi(X_stage1_reg[2][2]),.tw(W164),.y(x_stage2[2][2]));
csd_multiplier csd7(.xi(X_stage1_reg[2][3]),.tw(W166),.y(x_stage2[2][3]));

bs4_complex bs4_stage2_3(.x(x_stage2_3proper),.X(X_stage2[2]));

csd_multiplier csd8(.xi(X_stage1_reg[3][0]),.tw(W160),.y(x_stage2[3][0]));
csd_multiplier csd9(.xi(X_stage1_reg[3][1]),.tw(W163),.y(x_stage2[3][1]));
csd_multiplier csd10(.xi(X_stage1_reg[3][2]),.tw(W166),.y(x_stage2[3][2]));
csd_multiplier csd11(.xi(X_stage1_reg[3][3]),.tw(W169),.y(x_stage2[3][3]));

bs4_complex bs4_stage2_4(.x(x_stage2_4proper),.X(X_stage2[3]));
endmodule