library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity output_addr_decoding is
  port (
    BANK1: in std_ulogic_vector(4 downto 0);
    BANK1_ZERO: in std_ulogic;
    BANK2: in std_ulogic_vector(1 downto 0);
    CS: in std_ulogic;
    MODE: in std_ulogic;
    RAMG_OK: in std_ulogic;
    RD_OR_RESET: in std_ulogic;
    nA14_H: in std_ulogic;
    nA15_H: in std_ulogic;
    nRESET_RAMG: in std_ulogic;
    AA13_OUT: out std_ulogic;
    AA14_OUT: out std_ulogic;
    RA14_OUT: out std_ulogic;
    RA15_OUT: out std_ulogic;
    RA16_OUT: out std_ulogic;
    RA17_OUT: out std_ulogic;
    RA18_OUT: out std_ulogic;
    RAM_CS_OUT: out std_ulogic;
    nRAM_CS_OUT: out std_ulogic;
    nROM_CS_OUT: out std_ulogic
  );
end entity;

architecture kingfish of output_addr_decoding is
  signal A14_H: std_ulogic;
  signal EP1_nY: std_ulogic;
  signal FE1_nY: std_ulogic;
  signal FG1_nY: std_ulogic;
  signal GD1_Y: std_ulogic;
  signal GJ1_Y: std_ulogic;
  signal GL1_Y: std_ulogic;
  signal GN1_Y: std_ulogic;
  signal GR1_Y: std_ulogic;
  signal GU1_Y: std_ulogic;
  signal ROM_CS: std_ulogic;
begin
  inst_EM1: INV
  port map (
    A => nA14_H,
    Y => A14_H
  );

  inst_EN1: INV
  port map (
    A => EP1_nY,
    Y => RA14_OUT
  );

  inst_EP1: AOI22
  port map (
    A => A14_H,
    B => BANK1_ZERO,
    C => A14_H,
    D => BANK1(0),
    nY => EP1_nY
  );

  inst_FE1: OAI21
  port map (
    A => BANK2(1),
    B => MODE,
    C => A14_H,
    nY => FE1_nY
  );

  inst_FF1: INV
  port map (
    A => FE1_nY,
    Y => AA14_OUT
  );

  inst_FG1: OAI21
  port map (
    A => BANK2(0),
    B => MODE,
    C => A14_H,
    nY => FG1_nY
  );

  inst_FH1: INV
  port map (
    A => FG1_nY,
    Y => AA13_OUT
  );

  inst_GD1: NAND2
  port map (
    A => BANK1(1),
    B => A14_H,
    Y => GD1_Y
  );

  inst_GH1: INV
  port map (
    A => GD1_Y,
    Y => RA15_OUT
  );

  inst_GJ1: NAND2
  port map (
    A => BANK1(2),
    B => A14_H,
    Y => GJ1_Y
  );

  inst_GK1: INV
  port map (
    A => GJ1_Y,
    Y => RA16_OUT
  );

  inst_GL1: NAND2
  port map (
    A => BANK1(3),
    B => A14_H,
    Y => GL1_Y
  );

  inst_GM1: INV
  port map (
    A => GL1_Y,
    Y => RA17_OUT
  );

  inst_GN1: NAND2
  port map (
    A => BANK1(4),
    B => A14_H,
    Y => GN1_Y
  );

  inst_GP1: INV
  port map (
    A => GN1_Y,
    Y => RA18_OUT
  );

  inst_GR1: NAND4
  port map (
    A => nRESET_RAMG,
    B => nA14_H,
    C => RAMG_OK,
    D => CS,
    Y => GR1_Y
  );

  inst_GS1: INV
  port map (
    A => RAM_CS_OUT,
    Y => nRAM_CS_OUT
  );

  inst_GT1: INV
  port map (
    A => GR1_Y,
    Y => RAM_CS_OUT
  );

  inst_GU1: NAND2
  port map (
    A => nA15_H,
    B => RD_OR_RESET,
    Y => GU1_Y
  );

  inst_GV1: INV
  port map (
    A => GU1_Y,
    Y => ROM_CS
  );

  inst_GX1: INV
  port map (
    A => ROM_CS,
    Y => nROM_CS_OUT
  );

end architecture;
