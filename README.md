# FPGA System Verilog OSS Workflow Template

_I wanted something simple but what I actually got was a Makefile... &#x1f610;_

## What is this ?
A template project for a conventions-based FPGA workflow built with OSS tooling.  This is a SystemVerilog-based workflow and consists of the following steps:
1. Testbenches for unit and integration testing
2. Formal verification via Bounded Model Checking (BMC), induction and coverage
3. Synthesis and mapping
4. Placing and routing
5. Bitstream generation
6. Documentation generation

The workflow is based around a [GNU Makefile](https://www.gnu.org/software/make/manual/make.html) and OSS tooling, with an example [GitHub Actions](https://docs.github.com/en/actions) [CI script](.github/workflows/ci.yaml) that shows how to install any prerequisite tooling and invoke the [Makefile](build/GNUmakefile).

## Why ?
Because it's a chore to stand up a new project, especially when dealing with these sorts of ecosystems.  I also want to use my own IDE that I've got set up just how I like it, not some manufacturer's proprietary IDE.  I don't want grab tens or hundreds of gigabytes of tooling to flash an LED.  I don't want to have to 'register' or 'ask for a licence' just to download and use said tooling, only to find my particular part needs a paid-for edition.  I like experimenting.  Take your pick.

I wanted to strip my workflow back to something simpler that still allows automated testing, verification and synthesis.  The aim was for a simple setup and started out as a few BASH scripts before they became unweildy.  I'm not a fan of Python and didn't enjoy using MyHDL.  I like [SpinalHDL](https://github.com/SpinalHDL/SpinalHDL) - it's awesome in fact, and the reason I learned Scala - but there's a lot of abstraction over the hardware and consequently has all the associated complexity that comes with that.

## A Makefile...?
`make` is everywhere.  Admittedly, this is not a portable [Makefile](build/GNUmakefile).  But it could be, with some effort.  I tried to use BASH scripts and standard tooling but it became painfully obvious that what I really wanted was `make` or something like it.  A lot of other build tools are geared towards specific languages and a non-`make` tool is also another dependency, which I'm trying to avoid.  So I kept coming back to `make` - love it or hate it, it's pretty much a reliably available and widely understood tool.  A defacto tool.

## Prerequisites
Required packages for building, testing and verification.  Where possible I have tried to rely on commonly available tooling rather than take a new dependency.  Most of the dependencies are for the simulation and implementation parts of the workflow:
- [abc](https://github.com/YosysHQ/abc) - synthesis tool for mapping
- [bash](https://www.gnu.org/software/bash/) - BASH
- [boolector](https://github.com/boolector/boolector.git) - an SMT solver for formal verification
- [gmake](https://www.gnu.org/software/make/manual/make.html) - GNU Make
- [icestorm](https://github.com/YosysHQ/icestorm) - utilities for working with iCE40 FPGAs and bitstreams
- [iverilog](https://github.com/steveicarus/iverilog) - Icarus Verilog simulator for running testbenches
- [mdBook](https://github.com/rust-lang/mdBook) - compiles Markdown documentation into an HTML site
- [nextpnr](https://github.com/YosysHQ/nextpnr) - implementation tool for placing and routing (PnR)
- [rsync](https://rsync.samba.org/) - efficient file copying for constructing the documentation
- [sby](https://github.com/YosysHQ/sby.git) - a front-end for Yosys formal verification
- [sv2v](https://github.com/zachjs/sv2v) - conversion of SystemVerilog into Verilog for wider tool compatibility and semantic agreement
- [Wavedrom](https://github.com/wavedrom/wavedrom) - converts JSON5 descriptions into SVG images of waveforms, timings, circuits and registers
- [Yices](https://github.com/SRI-CSL/yices2.git) - an SMT solver for formal verification
- [Yosys](https://github.com/YosysHQ) - various front-end tools for formal verification and synthesis

## Conventions
The build infrastructure in this repository works off some conventions:
- Filenames and `module`s are treated as case-sensitive and must match
- The directory of the file being compiled, along with parent directories, are automatically added to the simulator's / synthesiser's include and library paths so other `module`s at the same level in the hierarchy are automatically discoverable (ie. no `include` is necessary)
- The `module`s and files must only reference `modules` and files in the same directory, a parent directory or a sibling directory, but not in sub-directories; this keeps the dependency arrows all pointing in the same direction and allows [Inversion of Control](https://en.wikipedia.org/wiki/Inversion_of_control); only the [Composition Root](https://blog.ploeh.dk/2011/07/28/CompositionRoot/) can break this rule as all dependencies must be known at synthesis time
- In the case of synthesis, the Composition Root is the top-level `module`; for simulation it is a Testbench or Formal Verification Proof
- Top-Level Modules:
  - Have a file extension of `.top.sv`; `.v` is used for `sv2v` pre-processed output
  - Must have at least one constraints file named `{BASENAME}.{TARGET}-{PACKAGE}.pcf` in order to be synthesisable; `{TARGET}` is the device, eg. `ice40up5k` and `{PACKAGE}` is the physical package, eg. `sg48`.  For synthesis, only `{TARGET}` needs to be taken into account, but PnR requires `{PACKAGE}`.
  - Can have a side-by-side file named `{BASENAME}.{TARGET}.args` containing arguments for module parameters and definitions; one line corresponds to one synthesised output variant
- Testbenches:
  - Live side-by-side with the `module` under test
  - Have a file named the same as the `module` under test, with an extension of `.tb.sv`
  - Have a `module` named `{BASENAME}Testbench` which is the top-level
  - Can have a side-by-side file named `{FILENAME}.args` containing arguments for module parameters and definitions; one line corresponds to one run
- Formal Verification Proofs:
  - Live side-by-side with the `module` under test
  - Have a file named the same as the `module` under test, with an extension of `.fv.sv`
  - Have a `module` named `{BASENAME}Proof` which is the top-level
  - Can have a side-by-side file named `{FILENAME}.args` containing arguments for module parameters and definitions; one line corresponds to one run
- SystemVerilog / Verilog `module`s:
  - Have a file extension of `.sv`; `.v` is used for `sv2v` pre-processed output
  - Have a `module` named `{BASENAME}` to allow them to be automatically discovered by the tooling
- SystemVerilog `interfaces`s:
  - Have a file extension of `.if.sv`
  - Have an `interface` named `{BASENAME}` to allow them to be automatically discovered by the tooling
- SystemVerilog / Verilog header files for `include`s:
  - Have a file extension of `.h.sv`
- Documentation:
  - Is built into an [mdBook](https://github.com/rust-lang/mdBook) using the template structure and files in `doc/book`
  - Also lives side-by-side with the SystemVerilog components for ease of reference and updating whilst navigating the code.  This documentation:
    - Has a file with an extension of `.md` for Markdown
    - Has file(s) with extensions of `.wd` for Wavedrom timing, register and circuit diagrams; these will be transformed to `.wd.svg` for inclusion in the book's Markdown

## Usage
The idea of this repository is that it's simply a starting point.  It is expected to be copied and then tweaked for a specific project, not used as a dependency.  There are some simple and lightweight test runners included - [TestbenchRunner](src/TestbenchRunner.sv) and [ProofRunner](src/ProofRunner.sv) - but another testing framework (or none at all) could be substituted.

Builds are out-of-tree so as not to clutter the source with objects and artefacts, so `cd build` and run `make` from there.  See the [ci.yaml](.github/workflows/ci.yaml) workflow for an example invocation.

All build artefacts are in `build/out` but there has no attempt at packaging; it is up to you what you pull out and how you package or use that.

I've added top-level blinky modules for some of the FPGA development boards that I have, since that's useful to me, but as long as the Yosys ecosystem can target a given architecture then this workflow ought to be able to target it too.  The Makefiles may need tweaking to do this.

## Build Status
[![CI](https://github.com/pete-restall/fpga-sv-template/actions/workflows/ci.yaml/badge.svg)](https://github.com/pete-restall/fpga-sv-template/actions/workflows/ci.yaml)
