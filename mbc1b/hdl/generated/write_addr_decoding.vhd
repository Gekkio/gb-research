library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity write_addr_decoding is
  port (
    A13_L: in std_ulogic;
    A15_L: in std_ulogic;
    WR: in std_ulogic;
    nA14_H: in std_ulogic;
    BANK1_WR: out std_ulogic;
    BANK2_WR: out std_ulogic;
    MODE_WR: out std_ulogic;
    RAMG_WR: out std_ulogic
  );
end entity;

architecture kingfish of write_addr_decoding is
  signal A14_H: std_ulogic;
  signal nA13_L: std_ulogic;
begin
  inst_EC1: INV
  port map (
    A => nA14_H,
    Y => A14_H
  );

  inst_ED1: INV
  port map (
    A => A13_L,
    Y => nA13_L
  );

  inst_EE1: NAND4
  port map (
    A => A15_L,
    B => WR,
    C => A14_H,
    D => A13_L,
    Y => BANK2_WR
  );

  inst_EF1: NAND4
  port map (
    A => A14_H,
    B => WR,
    C => nA13_L,
    D => A15_L,
    Y => MODE_WR
  );

  inst_EK1: NAND4
  port map (
    A => A13_L,
    B => WR,
    C => nA14_H,
    D => A15_L,
    Y => RAMG_WR
  );

  inst_EL1: NAND4
  port map (
    A => nA14_H,
    B => nA13_L,
    C => WR,
    D => A15_L,
    Y => BANK1_WR
  );

end architecture;
