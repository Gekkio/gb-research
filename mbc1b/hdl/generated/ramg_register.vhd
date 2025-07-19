library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity ramg_register is
  port (
    WR: in std_ulogic;
    nD: in std_ulogic_vector(3 downto 0);
    nRESET: in std_ulogic;
    RAMG_OK: out std_ulogic
  );
end entity;

architecture kingfish of ramg_register is
  signal FL1_Q: std_ulogic;
  signal FM1_nQ: std_ulogic;
  signal FN1_Q: std_ulogic;
  signal FP1_nQ: std_ulogic;
  signal FR1_Y: std_ulogic;
  signal RAMG1: std_ulogic;
  signal RAMG3: std_ulogic;
  signal RAMG_CLK: std_ulogic;
  signal nRAMG0: std_ulogic;
  signal nRAMG2: std_ulogic;
  signal nRAMG_CLK: std_ulogic;
begin
  inst_FJ1: INV
  port map (
    A => WR,
    Y => nRAMG_CLK
  );

  inst_FK1: INV
  port map (
    A => nRAMG_CLK,
    Y => RAMG_CLK
  );

  inst_FL1: DFFR
  port map (
    CLK => RAMG_CLK,
    Q => FL1_Q,
    nD => nD(0),
    nQ => nRAMG0,
    nRESET => nRESET
  );

  inst_FM1: DFFR
  port map (
    CLK => RAMG_CLK,
    Q => RAMG1,
    nD => nD(1),
    nQ => FM1_nQ,
    nRESET => nRESET
  );

  inst_FN1: DFFR
  port map (
    CLK => RAMG_CLK,
    Q => FN1_Q,
    nD => nD(2),
    nQ => nRAMG2,
    nRESET => nRESET
  );

  inst_FP1: DFFR
  port map (
    CLK => RAMG_CLK,
    Q => RAMG3,
    nD => nD(3),
    nQ => FP1_nQ,
    nRESET => nRESET
  );

  inst_FR1: NAND4
  port map (
    A => nRAMG2,
    B => RAMG1,
    C => RAMG3,
    D => nRAMG0,
    Y => FR1_Y
  );

  inst_FS1: INV
  port map (
    A => FR1_Y,
    Y => RAMG_OK
  );

end architecture;
