module shell(

    input logic signed [15:0] x[0:15][0:1],
    output logic signed [15:0] X[0:15][0:1],
    output logic OUT_VALID,

    input logic clk,
    input logic reset
);




///////////////////////////////////////////   STAGE 1 ////////////////////////////////////////////////

    logic MS1_OUT_VALID;
    logic signed [15:0] MS1_OUT[0:15][0:1];

    memory_stage1 ms1(
        .MS1_IN(x),
        .clk(clk),
        .reset(reset),
        .MS1_OUT(MS1_OUT),
        .MS1_OUT_VALID(MS1_OUT_VALID)
    );

    logic signed [15:0] PE1_OUT [0:15][0:1]; 
   
    pe_stage1  pe1( 
    .clk(clk),
    .rst(reset),
    .x_stage1(MS1_OUT), 
    .X_stage1(PE1_OUT),
    .ms1_out_valid(MS1_OUT_VALID)
);

    logic PE1_OUT_VALID;
    logic [3:0] valid_counter;
    always@(posedge clk)begin
        if(reset) valid_counter <=0;
        else if(MS1_OUT_VALID) valid_counter <= valid_counter +1;
        
        if(reset) PE1_OUT_VALID <=0;
        else if(valid_counter==11) PE1_OUT_VALID <=1;
    end

///////////////////////////////// STAGE 2 //////////////////////////////////////


    logic [15:0] MS2_OUT[0:15][0:1];
    logic MS2_OUT_VALID;

    memory_stage2 ms2(
        .clk(clk),
        .reset(reset),
        .MS2_IN(PE1_OUT),
        .MS2_OUT(MS2_OUT),
        .MS2_IN_VALID(PE1_OUT_VALID),

        .MS2_OUT_VALID(MS2_OUT_VALID)
    );

    logic signed [15:0] PE2_OUT[0:15][0:1]; 
    logic PE2_OUT_VALID;

    
    pe_stage2 pe2( 
    .clk(clk),
    .rst(reset),
    .x_stage2(MS2_OUT), 
    .X_stage2(PE2_OUT),
    .ms2_out_valid(MS2_OUT_VALID)
);

    logic [3:0] valid_counter2;
    always@(posedge clk)begin
        if(reset) valid_counter2 <=0;
        else if(MS2_OUT_VALID) valid_counter2 <= valid_counter2 +1;
        
        if(reset) PE2_OUT_VALID <=0;
        else if(valid_counter2==11) PE2_OUT_VALID<=1;
    end



///////////////////////////////////////  STAGE 3 //////////////////////////////////////////


    logic  [15:0] MS3_OUT[0:15][0:1];
    logic MS3_OUT_VALID;
    memory_stage3 ms3(
        .clk(clk),
        .reset(reset),
        .MS3_IN(PE2_OUT),
        .MS3_IN_VALID(PE2_OUT_VALID),

        .MS3_OUT(MS3_OUT),
        .MS3_OUT_VALID(MS3_OUT_VALID)
    );


    pe_stage3 pe3( 
        .clk(clk),
        .rst(reset),
        .x_stage3(MS3_OUT), 
        .X_stage3(X)
    );

    logic [1:0] valid_counter3;
    logic  PE3_OUT_VALID;
    always@(posedge clk)begin
        if(reset) valid_counter3 <=0;
        else if(MS3_OUT_VALID) valid_counter3 <= valid_counter3 +1;
        
        if(reset) PE3_OUT_VALID <=0;
        else if(valid_counter3==1) PE3_OUT_VALID<=1;
    end



    assign OUT_VALID = PE3_OUT_VALID;
    





endmodule
