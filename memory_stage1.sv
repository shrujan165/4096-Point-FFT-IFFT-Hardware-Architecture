module memory_stage1(
    input logic [15:0] MS1_IN[0:15][0:1],
    input logic clk,
    input logic reset,
    output logic  [15:0] MS1_OUT[0:15][0:1],

    output logic MS1_OUT_VALID
);


///////////////////////////////////////////////////////  MEMORY ////////////////////////////////////////////////////////////

    logic [15:0] RAM[0:15][0:255][0:1];
    logic [7:0] Address[0:15];
    //logic we[0:15];
    logic [15:0] Din[0:15][0:1];
    logic [15:0] Dout[0:15][0:1];


    always_ff@(posedge clk) begin
        for(int i=0;i<16;i++) begin
            RAM[i][Address[i]][0] <= Din[i][0];
            RAM[i][Address[i]][1] <= Din[i][1];
            Dout[i][0] <= RAM[i][Address[i]][0];
            Dout[i][1] <= RAM[i][Address[i]][1];
        end
    end


///////////////////////////////////////////////////////  LCS & RCS ////////////////////////////////////////////////////////////

    logic [3:0] RCS[0:15];
    logic [3:0] LCS[0:15];
    logic [7:0] Global_Counter;
    wire [3:0] Shift_Counter = Global_Counter[3:0];

    logic lcs_shift;

    always@(posedge clk)begin
        if(reset) lcs_shift <=0;
        else if(Shift_Counter ==15) lcs_shift <=1;
        else lcs_shift <=0;    
    end

    always@(posedge clk)begin
        if(reset)begin
            for(int i=0;i<16;i++) begin
                RCS[i] <=i;
                LCS[i] <=i;
            end
            Global_Counter <=0;
        end
        else begin
            if(Shift_Counter==15)begin
                RCS[0] <= RCS[15];
                for(int i=1;i<16;i++) RCS[i] <=RCS[i-1];     
            end
            if(lcs_shift==1)begin
                LCS[15] <= LCS[0];
                for(int i=0;i<15;i++) LCS[i] <=LCS[i+1];
            end


            Global_Counter <= Global_Counter +1;
        end
    end


////////////////////////////////////////////////////////// ADDRESS GENERATION //////////////////////////////////////////////////


    logic set;
    always@(posedge clk) begin
        if(reset) set<=0;
        else if(Global_Counter==255) set <=!set;
    end

    

    always_comb begin
        for(int i=0;i<16;i++) begin
            Din[i][0] = MS1_IN[RCS[i]][0];
            Din[i][1] = MS1_IN[RCS[i]][1];
        end
    end


    

    logic [7:0] Address_ROM[0:15];
    always_comb begin
        for(int i=0;i<16;i++) begin
            Address_ROM[i] = {RCS[i],Shift_Counter};
        end
    end

    always_comb begin
        if(set==0) begin
            for(int i=0;i<16;i++) begin
                Address[i] = Global_Counter;
            end
        end
        else begin
            for(int i=0;i<16;i++) begin
                Address[i] = Address_ROM[i];
            end
        end
    end

/////////////////////////////////////////////////////////  OUTPUT /////////////////////////////////////////////////////////    

    always_comb begin
        for(int i=0;i<16;i++) begin
            MS1_OUT[i][0] = Dout[LCS[i]][0];
            MS1_OUT[i][1] = Dout[LCS[i]][1];
        end
    end

/*
    integer fd1;
    integer fd2;
    integer fd;

    initial begin
            fd1 = $fopen("/home/thrinath/Documents/vlsi_arch/set0.txt", "w");
            fd2 = $fopen("/home/thrinath/Documents/vlsi_arch/set1.txt", "w");
    end

    always_comb begin
        if(set ==1 )fd =fd1;
        else fd =fd2;
    end

    always @(posedge clk) begin
        if (Global_Counter == 0 && reset != 1) begin
            
        
            // 256 rows
            for (int row = 0; row < 256; row++) begin 
                // 16 columns
                for (int col = 0; col < 16; col++) begin
                    // Print each element (space separated)
                    $fwrite(fd, "%04d ", RAM[col][row][15:0]);
                end
                
                // New line after each row
                $fwrite(fd, "\n");
            end
        end
    end

    final begin
        $fclose(fd1);
        $fclose(fd2);
    end
    */
///////////////////// VALID /////////////////////////
    always@(posedge clk) begin
        if(reset) MS1_OUT_VALID <=0;
        else if(set==1) MS1_OUT_VALID <=1;
    end
    


endmodule



module memory_stage2(
    input logic clk,
    input logic reset,
    input logic  [15:0] MS2_IN[0:15][0:1],
    input logic MS2_IN_VALID,

    output logic [15:0] MS2_OUT[0:15][0:1],
    output logic MS2_OUT_VALID
);


    logic [15:0] RAM[0:15][0:15][0:1];
    logic [3:0] Address[0:15];
  


    always_ff@(posedge clk) begin
        for(int i=0;i<16;i++) begin
            RAM[i][Address[i]][0] <= MS2_IN[i][0];
            RAM[i][Address[i]][1] <= MS2_IN[i][1];
            MS2_OUT[i][0] <= RAM[i][Address[i]][0];
            MS2_OUT[i][1] <= RAM[i][Address[i]][1];
        end
    end




    logic [3:0] counter;
    logic p;

    always@(posedge clk)begin
        if(reset) counter <=0;
        else if(MS2_IN_VALID)counter <= counter +1;

        if(reset) p <=0;
        else if(counter == 15) p<=1;

        if(reset) MS2_OUT_VALID <=0;
        else if(p==1 && counter==0) MS2_OUT_VALID  <=1; 
    end

    always_comb begin
        for(int i=0;i<16;i++) begin
            Address[i]  = counter;
        end
    end


endmodule


module memory_stage3(
    
    input logic clk,
    input logic reset,
    input logic [15:0] MS3_IN[0:15][0:1],
    input logic MS3_IN_VALID,

    output logic  [15:0] MS3_OUT[0:15][0:1],
    output logic MS3_OUT_VALID
);


///////////////////////////////////////////////////////  MEMORY ////////////////////////////////////////////////////////////

    logic [15:0] RAM[0:15][0:255][0:1];
    logic [7:0] Address[0:15];
    //logic we[0:15];
    logic [15:0] Din[0:15][0:1];
    logic [15:0] Dout[0:15][0:1];


    always_ff@(posedge clk) begin
        for(int i=0;i<16;i++) begin
            RAM[i][Address[i]][0] <= Din[i][0];
            RAM[i][Address[i]][1] <= Din[i][1];
            Dout[i][0] <= RAM[i][Address[i]][0];
            Dout[i][1] <= RAM[i][Address[i]][1];
        end
    end


///////////////////////////////////////////////////////  LCS & RCS ////////////////////////////////////////////////////////////

    logic [3:0] RCS[0:15];
    logic [3:0] LCS[0:15];
    logic [7:0] Global_Counter;
    wire [3:0] Shift_Counter = Global_Counter[3:0];

    logic lcs_shift;

    always@(posedge clk)begin
        if(reset) lcs_shift <=0;
        else if(Shift_Counter ==15) lcs_shift <=1;
        else lcs_shift <=0;    
    end

    always@(posedge clk)begin
        if(reset)begin
            for(int i=0;i<16;i++) begin
                RCS[i] <=i;
                LCS[i] <=i;
            end
            Global_Counter <=0;
        end
        else begin
            if(Shift_Counter==15)begin
                RCS[0] <= RCS[15];
                for(int i=1;i<16;i++) RCS[i] <=RCS[i-1];     
            end
            if(lcs_shift==1)begin
                LCS[15] <= LCS[0];
                for(int i=0;i<15;i++) LCS[i] <=LCS[i+1];
            end

            if(MS3_IN_VALID) Global_Counter <= Global_Counter +1;
        end
    end


////////////////////////////////////////////////////////// ADDRESS GENERATION //////////////////////////////////////////////////


    logic set;
    always@(posedge clk) begin
        if(reset) set<=0;
        else if(Global_Counter==255) set <=!set;
    end

    

    always_comb begin
        for(int i=0;i<16;i++) begin
            Din[i][0] = MS3_IN[RCS[i]][0];
            Din[i][1] = MS3_IN[RCS[i]][1];
        end
    end


    

    logic [7:0] Address_ROM[0:15];
    always_comb begin
        for(int i=0;i<16;i++) begin
            Address_ROM[i] = {RCS[i],Shift_Counter};
        end
    end

    always_comb begin
        if(set==0) begin
            for(int i=0;i<16;i++) begin
                Address[i] = Global_Counter;
            end
        end
        else begin
            for(int i=0;i<16;i++) begin
                Address[i] = Address_ROM[i];
            end
        end
    end

/////////////////////////////////////////////////////////  OUTPUT /////////////////////////////////////////////////////////    

    always_comb begin
        for(int i=0;i<16;i++) begin
            MS3_OUT[i][0] = Dout[LCS[i]][0];
            MS3_OUT[i][1] = Dout[LCS[i]][1];
        end
    end


////////////////////////////////////// VALID //////////////////////////////////////////////////////
    
    
    always@(posedge clk)begin
        if(reset) MS3_OUT_VALID <=0;
        else if(set==1) MS3_OUT_VALID <=1;
    end


endmodule
