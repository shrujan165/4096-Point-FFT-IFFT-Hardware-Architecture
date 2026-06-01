# 4096 point FFT
Implemented 4096 point FFT using three stages of processing element of radix 16 point FFT

# Requirements

### HDL: SystemVerilog

## Directory Tree

```text
FFT/IFFT 4096 point coding/
├─ bs16_complex.sv ....... Main function for implementing 16 point radix fft for any real/complex number
├─ cordic.sv ..... This is the cordic multiplier code

├─ memeory_stage1.sv ....... Stage 1 & 3 — 16 memory banks that cleverly rotate which slot data goes into (RCS) and comes out of (LCS), and every 256 cycles it switches between write new data in order and read old data in the shuffled order the butterfly needs.Stage 2 same idea but much smaller (16×16 instead of 16×256), and no rotation needed since the data is already in the right order by this point.

├─pe_stage1.sv...... It runs the 16 inputs through a BS16 butterfly, then multiplies each of the 15 outputs (except output 0, which just gets delayed to match)
by their Stage-I twiddle factor angle using 15 parallel CORDIC rotators.

├─pe_stage2.sv...... It does 16 point radix FFT calculation for second stage where inputs comes from memory bank.
├─pe_stage3.sv...... It does 16 point radix FFT calculation for third stage where inputs comes from memory bank.
├─shell.sv
├─ testbench.sv ........ For checking the functionality of 4096 point FFT
