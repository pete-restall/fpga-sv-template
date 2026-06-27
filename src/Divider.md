# Divider

A simple parameterised divider synchronous to `clock` and accepting a synchronous `reset`.

The module takes an integer `DIVISOR` parameter where `0 < DIVISOR < 2^32`.

The `DIVISOR` parameter is actually used as a synchronous counter to toggle an output, `toggle`, so that the frequency is `clock / (2 * DIVISOR)`Hz.

Example usage:
```verilog
Divider #(
	.DIVISOR(6_000_000)
) blinky_blinky (
	.clock(an_fpga_clock_input_12MHz),
	.sync_reset(fpga_global_sync_reset),
	.toggle(a_blinking_led_1Hz)
);
```

[![Example Waveform](./Divider.wd.svg)](./Divider.wd.svg)
