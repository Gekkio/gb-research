<!--
SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>

SPDX-License-Identifier: CC0-1.0
-->
# Game Boy MBC1B Memory Bank Controller chip

![](MBC1B_chip.jpg)

[KiCad Schematic](schematic/MBC1B.pdf)

Many older Game Boy cartridges include an MBC1 chip, which is used to memory
map larger ROM/RAM chips to the limited address space reserved to the cartridge
on Game Boy.

The Game Boy address space has two reserved areas for cartridges:

- a 32 kB "cartridge ROM address range" (0x0000-0x7FFF): essentially a 15-bit
  address + A15 pin used as chip select
- a 8 kB "cartridge RAM address range" (0xA000-0xBFFF): essentially a 13-bit
  address + CS pin used as chip select

In order to use ROM chips larger than 32 kB and/or RAM chips larger than 8 kB,
some kind of mapper chip is required.

For example, if a cartridge has a 128 kB ROM chip, the chip requires a 17-bit
address and would not work alone since the console only provides a 15-bit
address in the ROM address range. This kind of cartridge could wire the low 15
address bits directly to the ROM chip, and the high 2 address bits could
be provided by an MBC1 chip. This concept is called "ROM banking", and the two
extra bits provided by MBC1 are called the "bank number".

Note: There are multiple MBC1 versions and different implementations from
several manufacturers. The chip reverse engineered here is MBC1B manufactured
by NEC.

## Repository contents

- `schematic/`: KiCad schematics
- `MBC1B.svg`: Inkscape SVG with all connections traced and all cells identified
- `MBC1B.jpg`: a stitched photo of a decapped MBC1B die, taken with a 20x microscope objective
- `hdl/mbc1b_tb.vhd`: a VHDL testbench with several tests, also verified
  on a real MBC1B chip using a simple GPIO bit-bang setup
- `hdl/generated/`: a structural VHDL model generated from the schematics using
  Kingfish HDL generator. The main purpose is automated testing via simulation,
  so the model is *not* meant to be readable by humans
- `hdl/cells/`: VHDL models for the standard cells on the chip

## Running the HDL test suite

1. Install [Poetry](https://python-poetry.org/)
2. Install [GHDL](https://github.com/ghdl/ghdl)
3. Run `poetry install` in the `hdl` directory
4. Run `poetry run ./run.py` in the `hdl` directory

## Further reading

- [Game Boy: Complete Technical Reference](https://github.com/Gekkio/gb-ctr): contains a high-level description of MBC1
- [Tauwasser's MBC1 wiki page](https://wiki.tauwasser.eu/view/MBC1): contains technical information and a readable VHDL model of MBC1
