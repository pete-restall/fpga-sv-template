# InternalReset

> [!CAUTION]
> This is a good enough hack for a blinking LED demo but not much more.

Used when a development board does not have an external _synchronous_ reset input and the FPGA bitstream supports initial flip-flop states of `0`.

Example usage:
```verilog
InternalReset #(
	.NUMBER_OF_BITS(3)
) dut (
	.clock(an_fpga_clock_input),
	.sync_reset(sync_reset_for_fpga_logic)
);
```

[![Example Waveform](./InternalReset.wd.svg)](./InternalReset.wd.svg)
