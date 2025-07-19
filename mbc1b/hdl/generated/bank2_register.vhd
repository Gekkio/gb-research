library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity bank2_register is
  port (
    WR: in std_ulogic;
    nD: in std_ulogic_vector(1 downto 0);
    nRESET: in std_ulogic;
    BANK2: out std_ulogic_vector(1 downto 0)
  );
end entity;

architecture kingfish of bank2_register is
  signal BANK2_CLK: std_ulogic;
  signal FV1_nQ: std_ulogic;
  signal FX1_nQ: std_ulogic;
  signal nBANK2_CLK: std_ulogic;
begin
  inst_FT1: INV
  port map (
    A => WR,
    Y => nBANK2_CLK
  );

  inst_FU1: INV
  port map (
    A => nBANK2_CLK,
    Y => BANK2_CLK
  );

  inst_FV1: DFFR
  port map (
    CLK => BANK2_CLK,
    Q => BANK2(0),
    nD => nD(0),
    nQ => FV1_nQ,
    nRESET => nRESET
  );

  inst_FX1: DFFR
  port map (
    CLK => BANK2_CLK,
    Q => BANK2(1),
    nD => nD(1),
    nQ => FX1_nQ,
    nRESET => nRESET
  );

end architecture;
