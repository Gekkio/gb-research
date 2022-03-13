library ieee;
use ieee.std_logic_1164.all;

entity MBC1B is
  port (
    A13: in std_ulogic; -- PORT#A13
    A14: in std_ulogic; -- PORT#A14
    A15: in std_ulogic; -- PORT#A15
    D0: in std_ulogic; -- PORT#D0
    D1: in std_ulogic; -- PORT#D1
    D2: in std_ulogic; -- PORT#D2
    D3: in std_ulogic; -- PORT#D3
    D4: in std_ulogic; -- PORT#D4
    nCS: in std_ulogic; -- PORT#~{CS}
    nRD: in std_ulogic; -- PORT#~{RD}
    nRESET: in std_ulogic; -- PORT#~{RESET}
    nWR: in std_ulogic; -- PORT#~{WR}
    AA13: out std_ulogic; -- PORT#AA13
    AA14: out std_ulogic; -- PORT#AA14
    RA14: out std_ulogic; -- PORT#RA14
    RA15: out std_ulogic; -- PORT#RA15
    RA16: out std_ulogic; -- PORT#RA16
    RA17: out std_ulogic; -- PORT#RA17
    RA18: out std_ulogic; -- PORT#RA18
    RAM_CS: out std_ulogic; -- PORT#RAM_CS
    nRAM_CS: out std_ulogic; -- PORT#~{RAM_CS}
    nROM_CS: out std_ulogic -- PORT#~{ROM_CS}
  );
end entity;

architecture kingfish of MBC1B is
  signal A13_L: std_ulogic; -- /Address Decoding (register writes)/A13_L
  signal A15_L: std_ulogic; -- /Address Decoding (register writes)/A15_L
  signal AA13_OUT: std_ulogic; -- /Address Decoding (outputs)/AA13_OUT
  signal AA14_OUT: std_ulogic; -- /Address Decoding (outputs)/AA14_OUT
  signal AG1_OL: std_ulogic; -- Net-(AG1-Pad3)
  signal AG1_nOH: std_ulogic; -- Net-(AG1-Pad2)
  signal AH1_OL: std_ulogic; -- Net-(AH1-Pad3)
  signal AH1_nOH: std_ulogic; -- Net-(AH1-Pad2)
  signal AJ1_OL: std_ulogic; -- Net-(AJ1-Pad3)
  signal AJ1_nOH: std_ulogic; -- Net-(AJ1-Pad2)
  signal AK1_OL: std_ulogic; -- Net-(AK1-Pad3)
  signal AK1_nOH: std_ulogic; -- Net-(AK1-Pad2)
  signal AL1_OL: std_ulogic; -- Net-(AL1-Pad3)
  signal AL1_nOH: std_ulogic; -- Net-(AL1-Pad2)
  signal AM1_OL: std_ulogic; -- Net-(AM1-Pad3)
  signal AM1_nOH: std_ulogic; -- Net-(AM1-Pad2)
  signal BANK1_0: std_ulogic; -- /Address Decoding (outputs)/BANK1_0
  signal BANK1_1: std_ulogic; -- /Address Decoding (outputs)/BANK1_1
  signal BANK1_2: std_ulogic; -- /Address Decoding (outputs)/BANK1_2
  signal BANK1_3: std_ulogic; -- /Address Decoding (outputs)/BANK1_3
  signal BANK1_4: std_ulogic; -- /Address Decoding (outputs)/BANK1_4
  signal BANK1_WR: std_ulogic; -- /Address Decoding (register writes)/BANK1_WR
  signal BANK1_ZERO: std_ulogic; -- /Address Decoding (outputs)/BANK1_ZERO
  signal BANK2_0: std_ulogic; -- /Address Decoding (outputs)/BANK2_0
  signal BANK2_1: std_ulogic; -- /Address Decoding (outputs)/BANK2_1
  signal BANK2_WR: std_ulogic; -- /Address Decoding (register writes)/BANK2_WR
  signal CD1_OL: std_ulogic; -- Net-(CD1-Pad3)
  signal CD1_nOH: std_ulogic; -- Net-(CD1-Pad2)
  signal CE1_OL: std_ulogic; -- Net-(CE1-Pad3)
  signal CE1_nOH: std_ulogic; -- Net-(CE1-Pad2)
  signal CF1_OL: std_ulogic; -- Net-(CF1-Pad3)
  signal CF1_nOH: std_ulogic; -- Net-(CF1-Pad2)
  signal CG1_OL: std_ulogic; -- Net-(CG1-Pad3)
  signal CG1_nOH: std_ulogic; -- Net-(CG1-Pad2)
  signal CS: std_ulogic; -- /Address Decoding (outputs)/CS
  signal DB1_Y: std_ulogic; -- Net-(DB1-Pad2)
  signal MODE: std_ulogic; -- /Address Decoding (outputs)/MODE
  signal MODE_WR: std_ulogic; -- /Address Decoding (register writes)/MODE_WR
  signal RA14_OUT: std_ulogic; -- /Address Decoding (outputs)/RA14_OUT
  signal RA15_OUT: std_ulogic; -- /Address Decoding (outputs)/RA15_OUT
  signal RA16_OUT: std_ulogic; -- /Address Decoding (outputs)/RA16_OUT
  signal RA17_OUT: std_ulogic; -- /Address Decoding (outputs)/RA17_OUT
  signal RA18_OUT: std_ulogic; -- /Address Decoding (outputs)/RA18_OUT
  signal RAMG_OK: std_ulogic; -- /Address Decoding (outputs)/RAMG_OK
  signal RAMG_WR: std_ulogic; -- /Address Decoding (register writes)/RAMG_WR
  signal RAM_CS_OUT: std_ulogic; -- /Address Decoding (outputs)/RAM_CS_OUT
  signal RD_OR_RESET: std_ulogic; -- /Address Decoding (outputs)/RD_OR_RESET
  signal RESET: std_ulogic; -- /RESET
  signal WR: std_ulogic; -- /Address Decoding (register writes)/WR
  signal nA14_H: std_ulogic; -- /Address Decoding (outputs)/~{A14_H}
  signal nA15_H: std_ulogic; -- /Address Decoding (outputs)/~{A15_H}
  signal nD0: std_ulogic; -- /~{D0}
  signal nD1: std_ulogic; -- /~{D1}
  signal nD2: std_ulogic; -- /~{D2}
  signal nD3: std_ulogic; -- /~{D3}
  signal nD4: std_ulogic; -- /~{D4}
  signal nRAM_CS_OUT: std_ulogic; -- /Address Decoding (outputs)/~{RAM_CS_OUT}
  signal nRESET_BANK1: std_ulogic; -- /~{RESET_BANK1}
  signal nRESET_MODE_BANK2: std_ulogic; -- /~{RESET_MODE_BANK2}
  signal nRESET_RAMG: std_ulogic; -- /~{RESET_RAMG}
  signal nROM_CS_OUT: std_ulogic; -- /Address Decoding (outputs)/~{ROM_CS_OUT}
begin
  AG1_inst: entity work.OBUF
  port map (
    I => RA14_OUT,
    OL => AG1_OL,
    nOH => AG1_nOH
  );

  AH1_inst: entity work.OBUF
  port map (
    I => RA15_OUT,
    OL => AH1_OL,
    nOH => AH1_nOH
  );

  AJ1_inst: entity work.OBUF
  port map (
    I => RA16_OUT,
    OL => AJ1_OL,
    nOH => AJ1_nOH
  );

  AK1_inst: entity work.OBUF
  port map (
    I => RA17_OUT,
    OL => AK1_OL,
    nOH => AK1_nOH
  );

  AL1_inst: entity work.OBUF
  port map (
    I => RA18_OUT,
    OL => AL1_OL,
    nOH => AL1_nOH
  );

  AM1_inst: entity work.OBUF
  port map (
    I => nROM_CS_OUT,
    OL => AM1_OL,
    nOH => AM1_nOH
  );

  CD1_inst: entity work.OBUF
  port map (
    I => AA13_OUT,
    OL => CD1_OL,
    nOH => CD1_nOH
  );

  CE1_inst: entity work.OBUF
  port map (
    I => AA14_OUT,
    OL => CE1_OL,
    nOH => CE1_nOH
  );

  CF1_inst: entity work.OBUF
  port map (
    I => nRAM_CS_OUT,
    OL => CF1_OL,
    nOH => CF1_nOH
  );

  CG1_inst: entity work.OBUF
  port map (
    I => RAM_CS_OUT,
    OL => CG1_OL,
    nOH => CG1_nOH
  );

  DB1_inst: entity work.SCHMITT
  port map (
    A => nRESET,
    Y => DB1_Y
  );

  EB1_inst: entity work.INV
  port map (
    A => RESET,
    Y => nRESET_MODE_BANK2
  );

  ER1_inst: entity work.INV
  port map (
    A => RESET,
    Y => nRESET_BANK1
  );

  ES1_inst: entity work.INV
  port map (
    A => RESET,
    Y => nRESET_RAMG
  );

  GY1_inst: entity work.INV
  port map (
    A => DB1_Y,
    Y => RESET
  );

  U1_inst: entity work.ODRV
  port map (
    OL => CD1_OL,
    PIN => AA13,
    nOH => CD1_nOH
  );

  U2_inst: entity work.ODRV
  port map (
    OL => CE1_OL,
    PIN => AA14,
    nOH => CE1_nOH
  );

  U3_inst: entity work.ODRV
  port map (
    OL => CF1_OL,
    PIN => nRAM_CS,
    nOH => CF1_nOH
  );

  U4_inst: entity work.ODRV
  port map (
    OL => CG1_OL,
    PIN => RAM_CS,
    nOH => CG1_nOH
  );

  U5_inst: entity work.ODRV
  port map (
    OL => AG1_OL,
    PIN => RA14,
    nOH => AG1_nOH
  );

  U6_inst: entity work.ODRV
  port map (
    OL => AH1_OL,
    PIN => RA15,
    nOH => AH1_nOH
  );

  U7_inst: entity work.ODRV
  port map (
    OL => AJ1_OL,
    PIN => RA16,
    nOH => AJ1_nOH
  );

  U8_inst: entity work.ODRV
  port map (
    OL => AK1_OL,
    PIN => RA17,
    nOH => AK1_nOH
  );

  U9_inst: entity work.ODRV
  port map (
    OL => AL1_OL,
    PIN => RA18,
    nOH => AL1_nOH
  );

  U10_inst: entity work.ODRV
  port map (
    OL => AM1_OL,
    PIN => nROM_CS,
    nOH => AM1_nOH
  );

  bank1_register_inst: entity work.bank1_register
  port map (
    BANK1_0 => BANK1_0,
    BANK1_1 => BANK1_1,
    BANK1_2 => BANK1_2,
    BANK1_3 => BANK1_3,
    BANK1_4 => BANK1_4,
    BANK1_WR => BANK1_WR,
    BANK1_ZERO => BANK1_ZERO,
    nD0 => nD0,
    nD1 => nD1,
    nD2 => nD2,
    nD3 => nD3,
    nD4 => nD4,
    nRESET_BANK1 => nRESET_BANK1
  );

  bank2_register_inst: entity work.bank2_register
  port map (
    BANK2_0 => BANK2_0,
    BANK2_1 => BANK2_1,
    BANK2_WR => BANK2_WR,
    nD0 => nD0,
    nD1 => nD1,
    nRESET_MODE_BANK2 => nRESET_MODE_BANK2
  );

  input_gating_inst: entity work.input_gating
  port map (
    A13 => A13,
    A13_L => A13_L,
    A14 => A14,
    A15 => A15,
    A15_L => A15_L,
    CS => CS,
    D0 => D0,
    D1 => D1,
    D2 => D2,
    D3 => D3,
    D4 => D4,
    RD_OR_RESET => RD_OR_RESET,
    RESET => RESET,
    WR => WR,
    nA14_H => nA14_H,
    nA15_H => nA15_H,
    nCS => nCS,
    nD0 => nD0,
    nD1 => nD1,
    nD2 => nD2,
    nD3 => nD3,
    nD4 => nD4,
    nRD => nRD,
    nWR => nWR
  );

  mode_register_inst: entity work.mode_register
  port map (
    MODE => MODE,
    MODE_WR => MODE_WR,
    nD0 => nD0,
    nRESET_MODE_BANK2 => nRESET_MODE_BANK2
  );

  output_addr_decoding_inst: entity work.output_addr_decoding
  port map (
    AA13_OUT => AA13_OUT,
    AA14_OUT => AA14_OUT,
    BANK1_0 => BANK1_0,
    BANK1_1 => BANK1_1,
    BANK1_2 => BANK1_2,
    BANK1_3 => BANK1_3,
    BANK1_4 => BANK1_4,
    BANK1_ZERO => BANK1_ZERO,
    BANK2_0 => BANK2_0,
    BANK2_1 => BANK2_1,
    CS => CS,
    MODE => MODE,
    RA14_OUT => RA14_OUT,
    RA15_OUT => RA15_OUT,
    RA16_OUT => RA16_OUT,
    RA17_OUT => RA17_OUT,
    RA18_OUT => RA18_OUT,
    RAMG_OK => RAMG_OK,
    RAM_CS_OUT => RAM_CS_OUT,
    RD_OR_RESET => RD_OR_RESET,
    nA14_H => nA14_H,
    nA15_H => nA15_H,
    nRAM_CS_OUT => nRAM_CS_OUT,
    nRESET_RAMG => nRESET_RAMG,
    nROM_CS_OUT => nROM_CS_OUT
  );

  ramg_register_inst: entity work.ramg_register
  port map (
    RAMG_OK => RAMG_OK,
    RAMG_WR => RAMG_WR,
    nD0 => nD0,
    nD1 => nD1,
    nD2 => nD2,
    nD3 => nD3,
    nRESET_RAMG => nRESET_RAMG
  );

  write_addr_decoding_inst: entity work.write_addr_decoding
  port map (
    A13_L => A13_L,
    A15_L => A15_L,
    BANK1_WR => BANK1_WR,
    BANK2_WR => BANK2_WR,
    MODE_WR => MODE_WR,
    RAMG_WR => RAMG_WR,
    WR => WR,
    nA14_H => nA14_H
  );

end architecture;
