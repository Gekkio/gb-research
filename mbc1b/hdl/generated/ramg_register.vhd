library ieee;
use ieee.std_logic_1164.all;

entity ramg_register is
  port (
    RAMG_WR: in std_ulogic; -- /Address Decoding (register writes)/RAMG_WR
    nD0: in std_ulogic; -- /~{D0}
    nD1: in std_ulogic; -- /~{D1}
    nD2: in std_ulogic; -- /~{D2}
    nD3: in std_ulogic; -- /~{D3}
    nRESET_RAMG: in std_ulogic; -- /~{RESET_RAMG}
    RAMG_OK: out std_ulogic -- /Address Decoding (outputs)/RAMG_OK
  );
end entity;

architecture kingfish of ramg_register is
  signal FR1_Y: std_ulogic; -- Net-(FR1-Pad5)
  signal RAMG1: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/RAMG1
  signal RAMG3: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/RAMG3
  signal RAMG_CLK: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/RAMG_CLK
  signal UNCONNECTED_FL1_PAD4: std_ulogic; -- unconnected-(FL1-Pad4)
  signal UNCONNECTED_FM1_PAD7: std_ulogic; -- unconnected-(FM1-Pad7)
  signal UNCONNECTED_FN1_PAD4: std_ulogic; -- unconnected-(FN1-Pad4)
  signal UNCONNECTED_FP1_PAD7: std_ulogic; -- unconnected-(FP1-Pad7)
  signal nRAMG0: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/~{RAMG0}
  signal nRAMG2: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/~{RAMG2}
  signal nRAMG_CLK: std_ulogic; -- /RAMG register (0x0000-0x1FFF)/~{RAMG_CLK}
begin
  FJ1_inst: entity work.INV
  port map (
    A => RAMG_WR,
    Y => nRAMG_CLK
  );

  FK1_inst: entity work.INV
  port map (
    A => nRAMG_CLK,
    Y => RAMG_CLK
  );

  FL1_inst: entity work.DFFR
  port map (
    CLK => RAMG_CLK,
    Q => UNCONNECTED_FL1_PAD4,
    nD => nD0,
    nQ => nRAMG0,
    nRESET => nRESET_RAMG
  );

  FM1_inst: entity work.DFFR
  port map (
    CLK => RAMG_CLK,
    Q => RAMG1,
    nD => nD1,
    nQ => UNCONNECTED_FM1_PAD7,
    nRESET => nRESET_RAMG
  );

  FN1_inst: entity work.DFFR
  port map (
    CLK => RAMG_CLK,
    Q => UNCONNECTED_FN1_PAD4,
    nD => nD2,
    nQ => nRAMG2,
    nRESET => nRESET_RAMG
  );

  FP1_inst: entity work.DFFR
  port map (
    CLK => RAMG_CLK,
    Q => RAMG3,
    nD => nD3,
    nQ => UNCONNECTED_FP1_PAD7,
    nRESET => nRESET_RAMG
  );

  FR1_inst: entity work.NAND4
  port map (
    A => nRAMG2,
    B => RAMG1,
    C => RAMG3,
    D => nRAMG0,
    Y => FR1_Y
  );

  FS1_inst: entity work.INV
  port map (
    A => FR1_Y,
    Y => RAMG_OK
  );

end architecture;
