<!--
SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>

SPDX-License-Identifier: CC0-1.0
-->
# Game Boy SM83 CPU core

![SGB-CPU 01 chip](SGB-CPU_01_chip.jpg)

![Overview of the SoC die with the CPU core highlighted](soc_overview.jpg)

![Overview of SM83 CPU core SVG with one small section highlighted](sm83_overview.jpg)

![Zoomed-in detail of a SM83 CPU core section in the SVG](sm83_detail.jpg)

Game Boy consoles use a custom Sharp CPU core that resembles Z80 and 8080 but
is not exactly either. Some people use the name LR35902, but that is actually 
the name of the original Game Boy (DMG) SoC, which includes a huge amount of
other things than just the CPU despite being labeled "DMG-CPU". This is why I
call the chip a System-on-a-Chip (SoC), and the CPU core needs a separate name.

A couple of old Sharp databooks describe a "SM83" CPU core, which happens to
have an instruction set that is a perfect match with the Game Boy CPU. This
exact instruction set is unique and has not been seen in any other CPU cores,
so SM83 is the most probable name based on currently available information.
Personally I actually think that the CPU core might have an even older name,
since some very old Sharp SM-812/SM-813/SM-814 chips seem to have an unnamed
CPU core that seems at least like a relative. Since public information about
these chips is scarce, SM83 is the most accurate name.
You can read further information about this topic at the [NESdev forums](https://forums.nesdev.org/viewtopic.php?p=232656#p232656)

The reverse engineering work is based on an SGB-CPU 01 chip used in the Super
Game Boy. The chip is a DMG-CPU B chip with a different boot ROM, so the are
no relevant differences to DMG-CPU B, and all researched information applies to
the original Game Boy as well.

The HDL model passes the following tests:

- The whole Blargg's cpu_instrs test suite, except "02 - interrupts" which
  requires SoC peripherals and won't work with just the CPU core
- DAA test from [mooneye-test-suite](https://github.com/gekkio/mooneye-test-suite)

## What has been done

- a stitched top photo of the entire SM83 CPU core using a 40x objective
- an SVG file that contains hand-drawn traces of almost all interesting
  signals. Some repetitive areas and signals have not been traced because they
  follow a pattern that is already understood. Note: **the background photo is
  not in the repo** and needs to be downloaded separately from
  [here](https://gekkio.fi/files/decapped-chips/Frankenscope/Nintendo_SGB-CPU_01/)
- a **non-synthesizable** HDL model (written in VHDL) using a "medium
  abstraction level". It's meant for simulation and won't work directly on an
  FPGA. The abstraction level focuses on logical blocks and their connections,
  and does not include every single transistor, or even every single signal
- real-world ROM testing by plugging the CPU core into a "mock SoC" (not
  included in the repo at the moment). The CPU core passes all Blargg's
  cpu_instrs that don't require SoC peripherals. In practice this means
  everything except "02 - interrupts" which only passes partially

## What has not been done

- implementation of propagation delays. Estimating realistic propagation delays
  is complicated, especially due to dynamic logic. So far there has been no
  need, but this may change in the future when more testing is done and
  possible edge-cases are discovered
- perfect names for everything. A lot of effort has been spent on naming
  things, but for example the control unit signals currently have poor names

## What is planned

- KiCad schematics of at least the control unit. They already exist but aree
  not ready for release. The hand-written HDL will be replaced with HDL
  generated from the schematics once this is done

## Repository contents

- `SGB-CPU_01_sm83_core_40x.svg`: Inkscape SVG with most of the CPU core traced
  and identified. Download the background image [here](https://gekkio.fi/files/decapped-chips/Frankenscope/Nintendo_SGB-CPU_01/)
  separately and put it in the same folder to use it
- `hdl/`: a **non-synthesizable** HDL model of the SM83 CPU core
- `io-cell/`: a separate description of the "I/O cell" that connects the SoC
  data bus to the SM83 CPU core internal data buses

## Running the HDL test suite

1. Install [Poetry](https://python-poetry.org/)
2. Install [GHDL](https://github.com/ghdl/ghdl)
3. Run `poetry install` in the `hdl` directory
4. Run `poetry run test` in the `hdl` directory

## Further reading

- [Game Boy: Complete Technical Reference](https://github.com/Gekkio/gb-ctr):
  contains a high-level description of the CPU core and its instruction set
