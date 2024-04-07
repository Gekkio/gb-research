library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity bank2_register is
  port (
    WR: in std_ulogic; -- /Address Decoding (register writes)/BANK2_WR
    nD0: in std_ulogic; -- /~{D0}
    nD1: in std_ulogic; -- /~{D1}
    nRESET: in std_ulogic; -- /~{RESET_MODE_BANK2}
    BANK2_0: out std_ulogic; -- /Address Decoding (outputs)/BANK2_0
    BANK2_1: out std_ulogic -- /Address Decoding (outputs)/BANK2_1
  );
end entity;

architecture kingfish of bank2_register is
  signal BANK2_CLK: std_ulogic; -- /BANK2 register (0x4000-0x5FFF)/BANK2_CLK
  signal FV1_nQ: std_ulogic; -- unconnected-(FV1-~{Q}-Pad7)
  signal FX1_nQ: std_ulogic; -- unconnected-(FX1-~{Q}-Pad7)
  signal nBANK2_CLK: std_ulogic; -- /BANK2 register (0x4000-0x5FFF)/~{BANK2_CLK}
begin
  FT1_inst: INV -- FT1
  port map (
    A => WR,
    Y => nBANK2_CLK
  );

  FU1_inst: INV -- FU1
  port map (
    A => nBANK2_CLK,
    Y => BANK2_CLK
  );

  FV1_inst: DFFR -- FV1
  port map (
    CLK => BANK2_CLK,
    Q => BANK2_0,
    nD => nD0,
    nQ => FV1_nQ,
    nRESET => nRESET
  );

  FX1_inst: DFFR -- FX1
  port map (
    CLK => BANK2_CLK,
    Q => BANK2_1,
    nD => nD1,
    nQ => FX1_nQ,
    nRESET => nRESET
  );

end architecture;
