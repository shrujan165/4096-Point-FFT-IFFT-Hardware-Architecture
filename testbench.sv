module testbench();
    logic [15:0] in[0:4095][0:1];

    logic signed [15:0] in_fft[0:15][0:1];
    logic signed [15:0] out_fft[0:15][0:1];

    logic clk=0;

    always #5 clk <= ~clk;
    
    logic reset=1;

    int file, r;
    int val1, val2;

    initial begin
        file = $fopen("/home/thrinath/Documents/vlsi_arch/test_vectors/qam256_fixed.txt", "r");
        if (file == 0) begin
            $display("ERROR: Cannot open file");
            $finish;
        end
        for (int i = 0; i < 4096; i++) begin
            r = $fscanf(file, "%d %d\n", val1, val2);
            if (r != 2) begin
                $display("ERROR: Read failed at line %0d", i);
                $finish;
            end

            in[i][0] = val1[15:0];
            in[i][1]  = val2[15:0];
        end

        $fclose(file);

        $display("File loaded successfully");

        #7000 $finish;
    end

    


    logic [7:0] base =0;
    logic [11:0] idx[0:15] = '{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
    
    /*
     initial begin
        for(int i=0;i<16;i++) begin
            idx[i] = i;
        end
    end
    */
    
    
    always@(posedge clk) begin

        for(int i=0;i<16;i++)begin
            in_fft[i][0] = in[idx[i]][0];
            in_fft[i][1] = in[idx[i]][1];
            idx[i] = idx[i]+16;
        end
        reset <=0;
    end
    
  
    logic OUT_VALID;

    shell shell1(.x(in_fft),.clk(clk),.reset(reset),.X(out_fft),.OUT_VALID(OUT_VALID));

    

endmodule