library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity bank1_register is
  port (
    WR: in std_ulogic; -- /Address Decoding (register writes)/BANK1_WR
    nD0: in std_ulogic; -- /~{D0}
    nD1: in std_ulogic; -- /~{D1}
    nD2: in std_ulogic; -- /~{D2}
    nD3: in std_ulogic; -- /~{D3}
    nD4: in std_ulogic; -- /~{D4}
    nRESET: in std_ulogic; -- /~{RESET_BANK1}
    BANK1_0: out std_ulogic; -- /Address Decoding (outputs)/BANK1_0
    BANK1_1: out std_ulogic; -- /Address Decoding (outputs)/BANK1_1
    BANK1_2: out std_ulogic; -- /Address Decoding (outputs)/BANK1_2
    BANK1_3: out std_ulogic; -- /Address Decoding (outputs)/BANK1_3
    BANK1_4: out std_ulogic; -- /Address Decoding (outputs)/BANK1_4
    BANK1_ZERO: out std_ulogic -- /Address Decoding (outputs)/BANK1_ZERO
  );
end entity;

architecture kingfish of bank1_register is
  signal BANK1_CLK: std_ulogic; -- /BANK1 register (0x2000-0x3FFF)/BANK1_CLK
  signal GC1_Y: std_ulogic; -- Net-(GB1-A)
  signal nBANK1_0: std_ulogic; -- /BANK1 register (0x2000-0x3FFF)/~{BANK1_0}
  signal nBANK1_1: std_ulogic; -- /BANK1 register (0x2000-0x3FFF)/~{BANK1_1}
  signal nBANK1_2: std_ulogic; -- /BANK1 register (0x2000-0x3FFF)/~{BANK1_2}
  signal nBANK1_3: std_ulogic; -- /BANK1 register (0x2000-0x3FFF)/~{BANK1_3}
  signal nBANK1_4: std_ulogic; -- /BANK1 register (0x2000-0x3FFF)/~{BANK1_4}
  signal nBANK1_CLK: std_ulogic; -- /BANK1 register (0x2000-0x3FFF)/~{BANK1_CLK}
begin
  FA1_inst: INV -- FA1
  port map (
    A => WR,
    Y => nBANK1_CLK
  );

  FB1_inst: INV -- FB1
  port map (
    A => nBANK1_CLK,
    Y => BANK1_CLK
  );

  FC1_inst: DFFR -- FC1
  port map (
    CLK => BANK1_CLK,
    Q => BANK1_0,
    nD => nD0,
    nQ => nBANK1_0,
    nRESET => nRESET
  );

  FD1_inst: DFFR -- FD1
  port map (
    CLK => BANK1_CLK,
    Q => BANK1_1,
    nD => nD1,
    nQ => nBANK1_1,
    nRESET => nRESET
  );

  FY1_inst: DFFR -- FY1
  port map (
    CLK => BANK1_CLK,
    Q => BANK1_2,
    nD => nD2,
    nQ => nBANK1_2,
    nRESET => nRESET
  );

  FZ1_inst: DFFR -- FZ1
  port map (
    CLK => BANK1_CLK,
    Q => BANK1_3,
    nD => nD3,
    nQ => nBANK1_3,
    nRESET => nRESET
  );

  GA1_inst: DFFR -- GA1
  port map (
    CLK => BANK1_CLK,
    Q => BANK1_4,
    nD => nD4,
    nQ => nBANK1_4,
    nRESET => nRESET
  );

  GB1_inst: INV -- GB1
  port map (
    A => GC1_Y,
    Y => BANK1_ZERO
  );

  GC1_inst: NAND5 -- GC1
  port map (
    A => nBANK1_3,
    B => nBANK1_2,
    C => nBANK1_4,
    D => nBANK1_1,
    E => nBANK1_0,
    Y => GC1_Y
  );

end architecture;
