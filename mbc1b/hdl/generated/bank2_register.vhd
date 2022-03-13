library ieee;
use ieee.std_logic_1164.all;

entity bank2_register is
  port (
    BANK2_WR: in std_ulogic; -- /Address Decoding (register writes)/BANK2_WR
    nD0: in std_ulogic; -- /~{D0}
    nD1: in std_ulogic; -- /~{D1}
    nRESET_MODE_BANK2: in std_ulogic; -- /~{RESET_MODE_BANK2}
    BANK2_0: out std_ulogic; -- /Address Decoding (outputs)/BANK2_0
    BANK2_1: out std_ulogic -- /Address Decoding (outputs)/BANK2_1
  );
end entity;

architecture kingfish of bank2_register is
  signal BANK2_CLK: std_ulogic; -- /BANK2 register (0x4000-0x5FFF)/BANK2_CLK
  signal UNCONNECTED_FV1_PAD7: std_ulogic; -- unconnected-(FV1-Pad7)
  signal UNCONNECTED_FX1_PAD7: std_ulogic; -- unconnected-(FX1-Pad7)
  signal nBANK2_CLK: std_ulogic; -- /BANK2 register (0x4000-0x5FFF)/~{BANK2_CLK}
begin
  FT1_inst: entity work.INV
  port map (
    A => BANK2_WR,
    Y => nBANK2_CLK
  );

  FU1_inst: entity work.INV
  port map (
    A => nBANK2_CLK,
    Y => BANK2_CLK
  );

  FV1_inst: entity work.DFFR
  port map (
    CLK => BANK2_CLK,
    Q => BANK2_0,
    nD => nD0,
    nQ => UNCONNECTED_FV1_PAD7,
    nRESET => nRESET_MODE_BANK2
  );

  FX1_inst: entity work.DFFR
  port map (
    CLK => BANK2_CLK,
    Q => BANK2_1,
    nD => nD1,
    nQ => UNCONNECTED_FX1_PAD7,
    nRESET => nRESET_MODE_BANK2
  );

end architecture;
