library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity mode_register is
  port (
    WR: in std_ulogic; -- /Address Decoding (register writes)/MODE_WR
    nD0: in std_ulogic; -- /~{D0}
    nRESET: in std_ulogic; -- /~{RESET_MODE_BANK2}
    MODE: out std_ulogic -- /Address Decoding (outputs)/MODE
  );
end entity;

architecture kingfish of mode_register is
  signal EJ1_nQ: std_ulogic; -- unconnected-(EJ1-~{Q}-Pad7)
  signal MODE_CLK: std_ulogic; -- /MODE register (0x6000-0x7FFF)/MODE_CLK
  signal nMODE_CLK: std_ulogic; -- /MODE register (0x6000-0x7FFF)/~{MODE_CLK}
begin
  EG1_inst: INV -- EG1
  port map (
    A => WR,
    Y => nMODE_CLK
  );

  EH1_inst: INV -- EH1
  port map (
    A => nMODE_CLK,
    Y => MODE_CLK
  );

  EJ1_inst: DFFR -- EJ1
  port map (
    CLK => MODE_CLK,
    Q => MODE,
    nD => nD0,
    nQ => EJ1_nQ,
    nRESET => nRESET
  );

end architecture;
