library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity input_gating is
  port (
    A13_IN: in std_ulogic; -- /A13
    A14_IN: in std_ulogic; -- /A14
    A15_IN: in std_ulogic; -- /A15
    D0_IN: in std_ulogic; -- /D0
    D1_IN: in std_ulogic; -- /D1
    D2_IN: in std_ulogic; -- /D2
    D3_IN: in std_ulogic; -- /D3
    D4_IN: in std_ulogic; -- /D4
    RESET: in std_ulogic; -- /RESET
    nCS_IN: in std_ulogic; -- /~{CS}
    nRD_IN: in std_ulogic; -- /~{RD}
    nWR_IN: in std_ulogic; -- /~{WR}
    A13_L: out std_ulogic; -- /Address Decoding (register writes)/A13_L
    A15_L: out std_ulogic; -- /Address Decoding (register writes)/A15_L
    CS: out std_ulogic; -- /Address Decoding (outputs)/CS
    RD_OR_RESET: out std_ulogic; -- /Address Decoding (outputs)/RD_OR_RESET
    WR: out std_ulogic; -- /Address Decoding (register writes)/WR
    nA14_H: out std_ulogic; -- /Address Decoding (outputs)/~{A14_H}
    nA15_H: out std_ulogic; -- /Address Decoding (outputs)/~{A15_H}
    nD0: out std_ulogic; -- /~{D0}
    nD1: out std_ulogic; -- /~{D1}
    nD2: out std_ulogic; -- /~{D2}
    nD3: out std_ulogic; -- /~{D3}
    nD4: out std_ulogic -- /~{D4}
  );
end entity;

architecture kingfish of input_gating is
  signal nRESET_NAND: std_ulogic; -- /Input Gating/~{RESET_NAND}
begin
  AA1_inst: NOR2_PWR -- AA1
  port map (
    A => RESET,
    B => nCS_IN,
    Y => CS
  );

  AB1_inst: NOR2_PWR -- AB1
  port map (
    A => RESET,
    B => nWR_IN,
    Y => WR
  );

  AC1_inst: NOR2_PWR -- AC1
  port map (
    A => RESET,
    B => A15_IN,
    Y => A15_L
  );

  AD1_inst: NAND2_PWR -- AD1
  port map (
    A => A14_IN,
    B => nRESET_NAND,
    Y => nA14_H
  );

  AE1_inst: NAND2_PWR -- AE1
  port map (
    A => A15_IN,
    B => nRESET_NAND,
    Y => nA15_H
  );

  AF1_inst: NOR2_PWR -- AF1
  port map (
    A => RESET,
    B => A13_IN,
    Y => A13_L
  );

  BA1_inst: NAND2_PWR -- BA1
  port map (
    A => nRESET_NAND,
    B => D1_IN,
    Y => nD1
  );

  BB1_inst: NAND2_PWR -- BB1
  port map (
    A => nRESET_NAND,
    B => D0_IN,
    Y => nD0
  );

  CA1_inst: NAND2_PWR -- CA1
  port map (
    A => D2_IN,
    B => nRESET_NAND,
    Y => nD2
  );

  CB1_inst: NAND2_PWR -- CB1
  port map (
    A => D3_IN,
    B => nRESET_NAND,
    Y => nD3
  );

  CC1_inst: NAND2_PWR -- CC1
  port map (
    A => D4_IN,
    B => nRESET_NAND,
    Y => nD4
  );

  DA1_inst: NAND2_PWR -- DA1
  port map (
    A => nRD_IN,
    B => nRESET_NAND,
    Y => RD_OR_RESET
  );

  EA1_inst: INV -- EA1
  port map (
    A => RESET,
    Y => nRESET_NAND
  );

end architecture;
