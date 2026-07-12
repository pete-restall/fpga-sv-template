# The Puzhi Artix-7 PA35T Starlite Development Board

The top-level module for blinking a the two LEDs on the [Puzhi Artix-7 PA35T Starlite](https://www.en.puzhi.com/Product/AMD-FPGA-Development-Board/Artix-7/PA35T-StarLite.html) Development Board.

The board has a 200MHz LVDS clock input at balls [`R4`,`T4`] with two blue LEDs.  Ball `W22` of the FPGA connects to `LED1` and `Y22` is `LED2`.  We'll blink them alternately because reasons.

> [!IMPORTANT]
> The board can be programmed with [openFPGALoader](https://github.com/trabucayre/openFPGALoader)[^1].  As usual, `openFPGALoader` makes some assumptions based on the file extension.  As a result, `Makefile.xc7` will also generate a `.bit` as well as a `.bits` artefact.

[^1]: [Xilinx-specific openFPGALoader documentation](https://trabucayre.github.io/openFPGALoader/vendors/xilinx.html)

## Programming

The board is not supported directly by `openFPGALoader` but it does present itself as a Digilent cable meaning that it can be programmed with the following command:

```bash
$ openFPGALoader -c digilent_ad out/xc7a35t/fgg484/toplevel/puzhi-pa35t-starlite/PuzhiPa35tStarlite.1.bit
```
