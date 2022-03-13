<!--
SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>

SPDX-License-Identifier: CC0-1.0
-->

# SM83 IO cell

<a href="sm83_io_cell.png">

![sm83_io_cell_thumbnail.png](sm83_io_cell_thumbnail.png)

</a>

[sm83_io_cell.svg](sm83_io_cell.svg) is an Inkscape SVG that includes all
traces as labeled objects (not layers!).

## Connections

* **EXT_DATA**: Bidirectional connection to the main SoC data bus
* **INT_DATA**: Bidirectional connection to one of the SM83 CPU core data buses
* **ALU_DATA**: Input connection from the ALU output bus
* **TEST_T1**: Low under normal conditions, but if raised high, isolates the main
  SoC data bus (EXT_DATA) from the CPU core by disabling all EXT_DATA bus circuitry
* **PRECHARGE_CLK**: Clock used for precharging and dynamic logic in the CPU core.
  If low, both EXT_DATA and INT_DATA are pulled high to precharge the parasitic bus
  capacitance, and other bus circuitry is disabled
  If high, a pass transistor between INT_DATA/EXT_DATA is activated
* **ALU_DATA_OE**: If high and ALU_DATA is low, activates a low-side driver on
  the INT_DATA bus. Basically allows data to flow from ALU_DATA to
  INT_DATA/EXT_DATA, but only a low-side driver is used because the target
  buses use precharging

## License

Licensed under Creative Commons Attribution 4.0 International.

The background image is a cropped version of the dmg-cpu-a decap photo from
[siliconpr0n.org](https://siliconpr0n.org/map/nintendo/dmg-cpu-a/), and is used
in accordance to the CC BY 4.0 license.
