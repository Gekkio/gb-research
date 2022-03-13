library ieee;
use ieee.std_logic_1164.all;

entity input_gating is
  port (
    A13: in std_ulogic; -- PORT#A13
    A14: in std_ulogic; -- PORT#A14
    A15: in std_ulogic; -- PORT#A15
    D0: in std_ulogic; -- PORT#D0
    D1: in std_ulogic; -- PORT#D1
    D2: in std_ulogic; -- PORT#D2
    D3: in std_ulogic; -- PORT#D3
    D4: in std_ulogic; -- PORT#D4
    RESET: in std_ulogic; -- /RESET
    nCS: in std_ulogic; -- PORT#~{CS}
    nRD: in std_ulogic; -- PORT#~{RD}
    nWR: in std_ulogic; -- PORT#~{WR}
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
  AA1_inst: entity work.NOR2_PWR
  port map (
    A => RESET,
    B => nCS,
    Y => CS
  );

  AB1_inst: entity work.NOR2_PWR
  port map (
    A => RESET,
    B => nWR,
    Y => WR
  );

  AC1_inst: entity work.NOR2_PWR
  port map (
    A => RESET,
    B => A15,
    Y => A15_L
  );

  AD1_inst: entity work.NAND2_PWR
  port map (
    A => A14,
    B => nRESET_NAND,
    Y => nA14_H
  );

  AE1_inst: entity work.NAND2_PWR
  port map (
    A => A15,
    B => nRESET_NAND,
    Y => nA15_H
  );

  AF1_inst: entity work.NOR2_PWR
  port map (
    A => RESET,
    B => A13,
    Y => A13_L
  );

  BA1_inst: entity work.NAND2_PWR
  port map (
    A => nRESET_NAND,
    B => D1,
    Y => nD1
  );

  BB1_inst: entity work.NAND2_PWR
  port map (
    A => nRESET_NAND,
    B => D0,
    Y => nD0
  );

  CA1_inst: entity work.NAND2_PWR
  port map (
    A => D2,
    B => nRESET_NAND,
    Y => nD2
  );

  CB1_inst: entity work.NAND2_PWR
  port map (
    A => D3,
    B => nRESET_NAND,
    Y => nD3
  );

  CC1_inst: entity work.NAND2_PWR
  port map (
    A => D4,
    B => nRESET_NAND,
    Y => nD4
  );

  DA1_inst: entity work.NAND2_PWR
  port map (
    A => nRD,
    B => nRESET_NAND,
    Y => RD_OR_RESET
  );

  EA1_inst: entity work.INV
  port map (
    A => RESET,
    Y => nRESET_NAND
  );

end architecture;
