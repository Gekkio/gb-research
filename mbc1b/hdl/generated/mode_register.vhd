library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity mode_register is
  port (
    WR: in std_ulogic;
    nD0: in std_ulogic;
    nRESET: in std_ulogic;
    MODE: out std_ulogic
  );
end entity;

architecture kingfish of mode_register is
  signal EJ1_nQ: std_ulogic;
  signal MODE_CLK: std_ulogic;
  signal nMODE_CLK: std_ulogic;
begin
  inst_EG1: INV
  port map (
    A => WR,
    Y => nMODE_CLK
  );

  inst_EH1: INV
  port map (
    A => nMODE_CLK,
    Y => MODE_CLK
  );

  inst_EJ1: DFFR
  port map (
    CLK => MODE_CLK,
    Q => MODE,
    nD => nD0,
    nQ => EJ1_nQ,
    nRESET => nRESET
  );

end architecture;
