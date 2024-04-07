library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity output_addr_decoding is
  port (
    BANK1_0: in std_ulogic; -- /Address Decoding (outputs)/BANK1_0
    BANK1_1: in std_ulogic; -- /Address Decoding (outputs)/BANK1_1
    BANK1_2: in std_ulogic; -- /Address Decoding (outputs)/BANK1_2
    BANK1_3: in std_ulogic; -- /Address Decoding (outputs)/BANK1_3
    BANK1_4: in std_ulogic; -- /Address Decoding (outputs)/BANK1_4
    BANK1_ZERO: in std_ulogic; -- /Address Decoding (outputs)/BANK1_ZERO
    BANK2_0: in std_ulogic; -- /Address Decoding (outputs)/BANK2_0
    BANK2_1: in std_ulogic; -- /Address Decoding (outputs)/BANK2_1
    CS: in std_ulogic; -- /Address Decoding (outputs)/CS
    MODE: in std_ulogic; -- /Address Decoding (outputs)/MODE
    RAMG_OK: in std_ulogic; -- /Address Decoding (outputs)/RAMG_OK
    RD_OR_RESET: in std_ulogic; -- /Address Decoding (outputs)/RD_OR_RESET
    nA14_H: in std_ulogic; -- /Address Decoding (outputs)/~{A14_H}
    nA15_H: in std_ulogic; -- /Address Decoding (outputs)/~{A15_H}
    nRESET_RAMG: in std_ulogic; -- /~{RESET_RAMG}
    AA13_OUT: out std_ulogic; -- /Address Decoding (outputs)/AA13_OUT
    AA14_OUT: out std_ulogic; -- /Address Decoding (outputs)/AA14_OUT
    RA14_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA14_OUT
    RA15_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA15_OUT
    RA16_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA16_OUT
    RA17_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA17_OUT
    RA18_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA18_OUT
    RAM_CS_OUT: out std_ulogic; -- /Address Decoding (outputs)/RAM_CS_OUT
    nRAM_CS_OUT: out std_ulogic; -- /Address Decoding (outputs)/~{RAM_CS_OUT}
    nROM_CS_OUT: out std_ulogic -- /Address Decoding (outputs)/~{ROM_CS_OUT}
  );
end entity;

architecture kingfish of output_addr_decoding is
  signal A14_H: std_ulogic; -- /Address Decoding (outputs)/A14_H
  signal EP1_nY: std_ulogic; -- Net-(EN1-A)
  signal FE1_nY: std_ulogic; -- Net-(FE1-~{Y})
  signal FG1_nY: std_ulogic; -- Net-(FG1-~{Y})
  signal GD1_Y: std_ulogic; -- Net-(GD1-Y)
  signal GJ1_Y: std_ulogic; -- Net-(GJ1-Y)
  signal GL1_Y: std_ulogic; -- Net-(GL1-Y)
  signal GN1_Y: std_ulogic; -- Net-(GN1-Y)
  signal GR1_Y: std_ulogic; -- Net-(GR1-Y)
  signal GU1_Y: std_ulogic; -- Net-(GU1-Y)
  signal ROM_CS: std_ulogic; -- /Address Decoding (outputs)/ROM_CS
begin
  EM1_inst: INV -- EM1
  port map (
    A => nA14_H,
    Y => A14_H
  );

  EN1_inst: INV -- EN1
  port map (
    A => EP1_nY,
    Y => RA14_OUT
  );

  EP1_inst: AOI22 -- EP1
  port map (
    A => A14_H,
    B => BANK1_ZERO,
    C => A14_H,
    D => BANK1_0,
    nY => EP1_nY
  );

  FE1_inst: OAI21 -- FE1
  port map (
    A => BANK2_1,
    B => MODE,
    C => A14_H,
    nY => FE1_nY
  );

  FF1_inst: INV -- FF1
  port map (
    A => FE1_nY,
    Y => AA14_OUT
  );

  FG1_inst: OAI21 -- FG1
  port map (
    A => BANK2_0,
    B => MODE,
    C => A14_H,
    nY => FG1_nY
  );

  FH1_inst: INV -- FH1
  port map (
    A => FG1_nY,
    Y => AA13_OUT
  );

  GD1_inst: NAND2 -- GD1
  port map (
    A => BANK1_1,
    B => A14_H,
    Y => GD1_Y
  );

  GH1_inst: INV -- GH1
  port map (
    A => GD1_Y,
    Y => RA15_OUT
  );

  GJ1_inst: NAND2 -- GJ1
  port map (
    A => BANK1_2,
    B => A14_H,
    Y => GJ1_Y
  );

  GK1_inst: INV -- GK1
  port map (
    A => GJ1_Y,
    Y => RA16_OUT
  );

  GL1_inst: NAND2 -- GL1
  port map (
    A => BANK1_3,
    B => A14_H,
    Y => GL1_Y
  );

  GM1_inst: INV -- GM1
  port map (
    A => GL1_Y,
    Y => RA17_OUT
  );

  GN1_inst: NAND2 -- GN1
  port map (
    A => BANK1_4,
    B => A14_H,
    Y => GN1_Y
  );

  GP1_inst: INV -- GP1
  port map (
    A => GN1_Y,
    Y => RA18_OUT
  );

  GR1_inst: NAND4 -- GR1
  port map (
    A => nRESET_RAMG,
    B => nA14_H,
    C => RAMG_OK,
    D => CS,
    Y => GR1_Y
  );

  GS1_inst: INV -- GS1
  port map (
    A => RAM_CS_OUT,
    Y => nRAM_CS_OUT
  );

  GT1_inst: INV -- GT1
  port map (
    A => GR1_Y,
    Y => RAM_CS_OUT
  );

  GU1_inst: NAND2 -- GU1
  port map (
    A => nA15_H,
    B => RD_OR_RESET,
    Y => GU1_Y
  );

  GV1_inst: INV -- GV1
  port map (
    A => GU1_Y,
    Y => ROM_CS
  );

  GX1_inst: INV -- GX1
  port map (
    A => ROM_CS,
    Y => nROM_CS_OUT
  );

end architecture;
