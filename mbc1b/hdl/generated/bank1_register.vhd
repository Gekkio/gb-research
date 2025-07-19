library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity bank1_register is
  port (
    WR: in std_ulogic;
    nD: in std_ulogic_vector(4 downto 0);
    nRESET: in std_ulogic;
    BANK1: out std_ulogic_vector(4 downto 0);
    BANK1_ZERO: out std_ulogic
  );
end entity;

architecture kingfish of bank1_register is
  signal BANK1_CLK: std_ulogic;
  signal GC1_Y: std_ulogic;
  signal nBANK1_0: std_ulogic;
  signal nBANK1_1: std_ulogic;
  signal nBANK1_2: std_ulogic;
  signal nBANK1_3: std_ulogic;
  signal nBANK1_4: std_ulogic;
  signal nBANK1_CLK: std_ulogic;
begin
  inst_FA1: INV
  port map (
    A => WR,
    Y => nBANK1_CLK
  );

  inst_FB1: INV
  port map (
    A => nBANK1_CLK,
    Y => BANK1_CLK
  );

  inst_FC1: DFFR
  port map (
    CLK => BANK1_CLK,
    Q => BANK1(0),
    nD => nD(0),
    nQ => nBANK1_0,
    nRESET => nRESET
  );

  inst_FD1: DFFR
  port map (
    CLK => BANK1_CLK,
    Q => BANK1(1),
    nD => nD(1),
    nQ => nBANK1_1,
    nRESET => nRESET
  );

  inst_FY1: DFFR
  port map (
    CLK => BANK1_CLK,
    Q => BANK1(2),
    nD => nD(2),
    nQ => nBANK1_2,
    nRESET => nRESET
  );

  inst_FZ1: DFFR
  port map (
    CLK => BANK1_CLK,
    Q => BANK1(3),
    nD => nD(3),
    nQ => nBANK1_3,
    nRESET => nRESET
  );

  inst_GA1: DFFR
  port map (
    CLK => BANK1_CLK,
    Q => BANK1(4),
    nD => nD(4),
    nQ => nBANK1_4,
    nRESET => nRESET
  );

  inst_GB1: INV
  port map (
    A => GC1_Y,
    Y => BANK1_ZERO
  );

  inst_GC1: NAND5
  port map (
    A => nBANK1_3,
    B => nBANK1_2,
    C => nBANK1_4,
    D => nBANK1_1,
    E => nBANK1_0,
    Y => GC1_Y
  );

end architecture;
