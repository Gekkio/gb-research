library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity input_gating is
  port (
    A13_IN: in std_ulogic;
    A14_IN: in std_ulogic;
    A15_IN: in std_ulogic;
    D0_IN: in std_ulogic;
    D1_IN: in std_ulogic;
    D2_IN: in std_ulogic;
    D3_IN: in std_ulogic;
    D4_IN: in std_ulogic;
    RESET: in std_ulogic;
    nCS_IN: in std_ulogic;
    nRD_IN: in std_ulogic;
    nWR_IN: in std_ulogic;
    A13_L: out std_ulogic;
    A15_L: out std_ulogic;
    CS: out std_ulogic;
    RD_OR_RESET: out std_ulogic;
    WR: out std_ulogic;
    nA14_H: out std_ulogic;
    nA15_H: out std_ulogic;
    nD0: out std_ulogic;
    nD1: out std_ulogic;
    nD2: out std_ulogic;
    nD3: out std_ulogic;
    nD4: out std_ulogic
  );
end entity;

architecture kingfish of input_gating is
  signal nRESET_NAND: std_ulogic;
begin
  inst_AA1: NOR2_PWR
  port map (
    A => RESET,
    B => nCS_IN,
    Y => CS
  );

  inst_AB1: NOR2_PWR
  port map (
    A => RESET,
    B => nWR_IN,
    Y => WR
  );

  inst_AC1: NOR2_PWR
  port map (
    A => RESET,
    B => A15_IN,
    Y => A15_L
  );

  inst_AD1: NAND2_PWR
  port map (
    A => A14_IN,
    B => nRESET_NAND,
    Y => nA14_H
  );

  inst_AE1: NAND2_PWR
  port map (
    A => A15_IN,
    B => nRESET_NAND,
    Y => nA15_H
  );

  inst_AF1: NOR2_PWR
  port map (
    A => RESET,
    B => A13_IN,
    Y => A13_L
  );

  inst_BA1: NAND2_PWR
  port map (
    A => nRESET_NAND,
    B => D1_IN,
    Y => nD1
  );

  inst_BB1: NAND2_PWR
  port map (
    A => nRESET_NAND,
    B => D0_IN,
    Y => nD0
  );

  inst_CA1: NAND2_PWR
  port map (
    A => D2_IN,
    B => nRESET_NAND,
    Y => nD2
  );

  inst_CB1: NAND2_PWR
  port map (
    A => D3_IN,
    B => nRESET_NAND,
    Y => nD3
  );

  inst_CC1: NAND2_PWR
  port map (
    A => D4_IN,
    B => nRESET_NAND,
    Y => nD4
  );

  inst_DA1: NAND2_PWR
  port map (
    A => nRD_IN,
    B => nRESET_NAND,
    Y => RD_OR_RESET
  );

  inst_EA1: INV
  port map (
    A => RESET,
    Y => nRESET_NAND
  );

end architecture;
