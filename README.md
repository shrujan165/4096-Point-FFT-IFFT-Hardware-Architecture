# 4096 point FFT
Implemented 4096 point FFT using three stages of processing element of radix 16 point FFT

# Requirements

### HDL: SystemVerilog

## Directory Tree

```text
FFT/IFFT 4096 point coding/
├─ bs16_complex.sv ....... Main function for implementing 16 point radix fft for any real/complex number
├─ cordic.sv ..... This is the cordic multiplier code

├─ memeory_stage1.sv ....... Stage I & II — 16 memory banks that cleverly rotate which slot data goes into (RCS) and comes out of (LCS), and every 256 cycles it switches between write new data in order and read old data in the shuffled order the butterfly needs.Stage 2 same idea but much smaller (16×16 instead of 16×256), and no rotation needed since the data is already in the right order by this point.

├─pe_stage1.sv...... It runs the 16 inputs through a BS16 butterfly, then multiplies each of the 15 outputs (except output 0, which just gets delayed to match)
by their Stage-I twiddle factor angle using 15 parallel CORDIC rotators.

├─pe_stage2.sv......Same structure as pe_stage1 — BS16 butterfly followed by 15 CORDIC rotators — but the twiddle angle formula uses n × (k+1) × 256 instead of n × (k+1) × 16, reflecting the larger twiddle factors needed at Stage-II of the 4096-point FFT.

├─pe_stage3.sv......  Stage-III is the final stage, no twiddle factor multiplication is required, the BS16 butterfly outputs its results directly without using a CORDIC.

├─shell.sv..... This is the top-level  module that combines all three memory+butterfly stages together in order — memory_stage1 → pe_stage1 → memory_stage2 → pe_stage2 → memory_stage3 → pe_stage3

├─ testbench.sv ........ For checking the functionality of 4096 point FFT
