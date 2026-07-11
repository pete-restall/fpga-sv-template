# The iCE Sugar Development Board

The top-level module for blinking an LED on the [iCE Sugar](https://github.com/wuxx/icesugar) Development Board.

This board has a 12MHz clock input and an RGB LED.  Feature creep has dictated that we push the boat out and blink all three components.  It's what people want.

To really stretch ourselves and push the frontiers of high technology, we will use parameterisation to build several bitstream variants that blink the LEDs at different rates.

## Programming

The board can be programmed using the [icesprog](https://github.com/wuxx/icesugar/tree/master/tools) utility:

```bash
$ icesprog -w out/ice40up5k/sg48/toplevel/icesugar/IceSugar.1.bits
```
