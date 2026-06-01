# 4096 point FFT
Implemented 4096 point FFT using three stages of processing element of radix 16 point FFT

## Directory Tree

```text
FFT/IFFT 4096 point coding/
├─ bs16_complex.sv ....... Main function for Huffman coding
├─ cordic.sv ..... RTL testbench
├─ memeory_stage1.sv ....... Top module with Block Memory, VIO for reset, and ILA
├─pe_stage1.sv
├─pe_stage2.sv
├─pe_stage3.sv
├─shell.sv
├─ testbench.sv ........ 
