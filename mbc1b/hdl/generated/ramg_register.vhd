library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity ramg_register is
  port (
    WR: in std_ulogic; -- /Address Decoding (register writes)/RAMG_WR
    nD0: in std_ulogic; -- /~{D0}
    nD1: in std_ulogic; -- /~{D1}
    nD2: in std_ulogic; -- /~{D2}
    nD3: in std_ulogic; -- /~{D3}
    nRESET: in std_ulogic; -- /~{RESET_RAMG}
    RAMG_OK: out std_ulogic -- /Address Decoding (outputs)/RAMG_OK
  );
end entity;

architecture kingfish of ramg_register is
  signal FL1_Q: std_ulogic; -- unconnected-(FL1-Q-Pad4)
  signal FM1_nQ: std_ulogic; -- unconnected-(FM1-~{Q}-Pad7)
  signal FN1_Q: std_ulogic; -- unconnected-(FN1-Q-Pad4)
  signal FP1_nQ: std_ulogic; -- unconnected-(FP1-~{Q}-Pad7)
  signal FR1_Y: std_ulogic; -- Net-(FR1-Y)
  signal RAMG1: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/RAMG1
  signal RAMG3: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/RAMG3
  signal RAMG_CLK: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/RAMG_CLK
  signal nRAMG0: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/~{RAMG0}
  signal nRAMG2: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/~{RAMG2}
  signal nRAMG_CLK: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/~{RAMG_CLK}
begin
  FJ1_inst: INV -- FJ1
  port map (
    A => WR,
    Y => nRAMG_CLK
  );

  FK1_inst: INV -- FK1
  port map (
    A => nRAMG_CLK,
    Y => RAMG_CLK
  );

  FL1_inst: DFFR -- FL1
  port map (
    CLK => RAMG_CLK,
    Q => FL1_Q,
    nD => nD0,
    nQ => nRAMG0,
    nRESET => nRESET
  );

  FM1_inst: DFFR -- FM1
  port map (
    CLK => RAMG_CLK,
    Q => RAMG1,
    nD => nD1,
    nQ => FM1_nQ,
    nRESET => nRESET
  );

  FN1_inst: DFFR -- FN1
  port map (
    CLK => RAMG_CLK,
    Q => FN1_Q,
    nD => nD2,
    nQ => nRAMG2,
    nRESET => nRESET
  );

  FP1_inst: DFFR -- FP1
  port map (
    CLK => RAMG_CLK,
    Q => RAMG3,
    nD => nD3,
    nQ => FP1_nQ,
    nRESET => nRESET
  );

  FR1_inst: NAND4 -- FR1
  port map (
    A => nRAMG2,
    B => RAMG1,
    C => RAMG3,
    D => nRAMG0,
    Y => FR1_Y
  );

  FS1_inst: INV -- FS1
  port map (
    A => FR1_Y,
    Y => RAMG_OK
  );

end architecture;
