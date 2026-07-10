# The Tang Primer 20k Development Board

The top-level module for blinking an LED on the [Tang Primer 20k](https://wiki.sipeed.com/hardware/en/tang/tang-primer-20k/primer-20k.html) Development Board.

> [!IMPORTANT]
> There is no LED on the core board.  For this demo to work, the core board needs to be in the Dock.  The Lite with the 8x LED PMOD extension will also work.

The core board has a 27MHz clock input at ball `H11` and the Dock has 6 orange LEDs.  Ball `L14` of the FPGA connects to `LED4`.

> [!IMPORTANT]
> The board can be programmed with [openFPGALoader](https://github.com/trabucayre/openFPGALoader)[^1].  Unfortunately, openFPGALoader will quite happily take any input file and (appear to) write it into the FPGA or flash.  What you will not find out, at least not at the time of this writing, is that any files that do not end in `.fs` will _not_ be uploaded into the FPGA[^2].  As a result, the Gowin portion of the `Makefile` will also generate a `.fs` as well as a `.bits` artefact.

[^1]: [Gowin-specific openFPGALoader documentation](https://trabucayre.github.io/openFPGALoader/vendors/gowin.html)
[^2]: I had to read the sourcecode to discover that, but only after a lot head-scratching, cursing and toolchain debugging across FreeBSD and two flavours of GNU/Linux.  Fun times.
