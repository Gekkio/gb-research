library ieee;
use ieee.std_logic_1164.all;

entity mode_register is
  port (
    MODE_WR: in std_ulogic; -- /Address Decoding (register writes)/MODE_WR
    nD0: in std_ulogic; -- /~{D0}
    nRESET_MODE_BANK2: in std_ulogic; -- /~{RESET_MODE_BANK2}
    MODE: out std_ulogic -- /Address Decoding (outputs)/MODE
  );
end entity;

architecture kingfish of mode_register is
  signal MODE_CLK: std_ulogic; -- /MODE register (0x6000-0x7FFF)/MODE_CLK
  signal UNCONNECTED_EJ1_PAD7: std_ulogic; -- unconnected-(EJ1-Pad7)
  signal nMODE_CLK: std_ulogic; -- /MODE register (0x6000-0x7FFF)/~{MODE_CLK}
begin
  EG1_inst: entity work.INV
  port map (
    A => MODE_WR,
    Y => nMODE_CLK
  );

  EH1_inst: entity work.INV
  port map (
    A => nMODE_CLK,
    Y => MODE_CLK
  );

  EJ1_inst: entity work.DFFR
  port map (
    CLK => MODE_CLK,
    Q => MODE,
    nD => nD0,
    nQ => UNCONNECTED_EJ1_PAD7,
    nRESET => nRESET_MODE_BANK2
  );

end architecture;
