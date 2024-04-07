library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity write_addr_decoding is
  port (
    A13_L: in std_ulogic; -- /Address Decoding (register writes)/A13_L
    A15_L: in std_ulogic; -- /Address Decoding (register writes)/A15_L
    WR: in std_ulogic; -- /Address Decoding (register writes)/WR
    nA14_H: in std_ulogic; -- /Address Decoding (outputs)/~{A14_H}
    BANK1_WR: out std_ulogic; -- /Address Decoding (register writes)/BANK1_WR
    BANK2_WR: out std_ulogic; -- /Address Decoding (register writes)/BANK2_WR
    MODE_WR: out std_ulogic; -- /Address Decoding (register writes)/MODE_WR
    RAMG_WR: out std_ulogic -- /Address Decoding (register writes)/RAMG_WR
  );
end entity;

architecture kingfish of write_addr_decoding is
  signal A14_H: std_ulogic; -- /Address Decoding (register writes)/A14_H
  signal nA13_L: std_ulogic; -- /Address Decoding (register writes)/~{A13_L}
begin
  EC1_inst: INV -- EC1
  port map (
    A => nA14_H,
    Y => A14_H
  );

  ED1_inst: INV -- ED1
  port map (
    A => A13_L,
    Y => nA13_L
  );

  EE1_inst: NAND4 -- EE1
  port map (
    A => A15_L,
    B => WR,
    C => A14_H,
    D => A13_L,
    Y => BANK2_WR
  );

  EF1_inst: NAND4 -- EF1
  port map (
    A => A14_H,
    B => WR,
    C => nA13_L,
    D => A15_L,
    Y => MODE_WR
  );

  EK1_inst: NAND4 -- EK1
  port map (
    A => A13_L,
    B => WR,
    C => nA14_H,
    D => A15_L,
    Y => RAMG_WR
  );

  EL1_inst: NAND4 -- EL1
  port map (
    A => nA14_H,
    B => nA13_L,
    C => WR,
    D => A15_L,
    Y => BANK1_WR
  );

end architecture;
