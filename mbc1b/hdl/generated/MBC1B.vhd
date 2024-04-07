library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity MBC1B is
  port (
    A13: in std_ulogic; -- /A13
    A14: in std_ulogic; -- /A14
    A15: in std_ulogic; -- /A15
    D0: in std_ulogic; -- /D0
    D1: in std_ulogic; -- /D1
    D2: in std_ulogic; -- /D2
    D3: in std_ulogic; -- /D3
    D4: in std_ulogic; -- /D4
    nCS: in std_ulogic; -- /~{CS}
    nRD: in std_ulogic; -- /~{RD}
    nRESET: in std_ulogic; -- /~{RESET}
    nWR: in std_ulogic; -- /~{WR}
    AA13: out std_ulogic; -- /AA13
    AA14: out std_ulogic; -- /AA14
    RA14: out std_ulogic; -- /RA14
    RA15: out std_ulogic; -- /RA15
    RA16: out std_ulogic; -- /RA16
    RA17: out std_ulogic; -- /RA17
    RA18: out std_ulogic; -- /RA18
    RAM_CS: out std_ulogic; -- /RAM_CS
    nRAM_CS: out std_ulogic; -- /~{RAM_CS}
    nROM_CS: out std_ulogic -- /~{ROM_CS}
  );
end entity;

architecture kingfish of MBC1B is
  signal AA1_Y: std_ulogic; -- /Address Decoding (outputs)/CS
  signal AB1_Y: std_ulogic; -- /Address Decoding (register writes)/WR
  signal AC1_Y: std_ulogic; -- /Address Decoding (register writes)/A15_L
  signal AD1_Y: std_ulogic; -- /Address Decoding (outputs)/~{A14_H}
  signal AE1_Y: std_ulogic; -- /Address Decoding (outputs)/~{A15_H}
  signal AF1_Y: std_ulogic; -- /Address Decoding (register writes)/A13_L
  signal AG1_OL: std_ulogic; -- Net-(AG1-OL)
  signal AG1_nOH: std_ulogic; -- Net-(AG1-~{OH})
  signal AH1_OL: std_ulogic; -- Net-(AH1-OL)
  signal AH1_nOH: std_ulogic; -- Net-(AH1-~{OH})
  signal AJ1_OL: std_ulogic; -- Net-(AJ1-OL)
  signal AJ1_nOH: std_ulogic; -- Net-(AJ1-~{OH})
  signal AK1_OL: std_ulogic; -- Net-(AK1-OL)
  signal AK1_nOH: std_ulogic; -- Net-(AK1-~{OH})
  signal AL1_OL: std_ulogic; -- Net-(AL1-OL)
  signal AL1_nOH: std_ulogic; -- Net-(AL1-~{OH})
  signal AM1_OL: std_ulogic; -- Net-(AM1-OL)
  signal AM1_nOH: std_ulogic; -- Net-(AM1-~{OH})
  signal CD1_OL: std_ulogic; -- Net-(CD1-OL)
  signal CD1_nOH: std_ulogic; -- Net-(CD1-~{OH})
  signal CE1_OL: std_ulogic; -- Net-(CE1-OL)
  signal CE1_nOH: std_ulogic; -- Net-(CE1-~{OH})
  signal CF1_OL: std_ulogic; -- Net-(CF1-OL)
  signal CF1_nOH: std_ulogic; -- Net-(CF1-~{OH})
  signal CG1_OL: std_ulogic; -- Net-(CG1-OL)
  signal CG1_nOH: std_ulogic; -- Net-(CG1-~{OH})
  signal DA1_Y: std_ulogic; -- /Address Decoding (outputs)/RD_OR_RESET
  signal DB1_Y: std_ulogic; -- Net-(DB1-Y)
  signal EE1_Y: std_ulogic; -- /Address Decoding (register writes)/BANK2_WR
  signal EF1_Y: std_ulogic; -- /Address Decoding (register writes)/MODE_WR
  signal EJ1_Q: std_ulogic; -- /Address Decoding (outputs)/MODE
  signal EK1_Y: std_ulogic; -- /Address Decoding (register writes)/RAMG_WR
  signal EL1_Y: std_ulogic; -- /Address Decoding (register writes)/BANK1_WR
  signal EN1_Y: std_ulogic; -- /Address Decoding (outputs)/RA14_OUT
  signal FC1_Q: std_ulogic; -- /Address Decoding (outputs)/BANK1_0
  signal FD1_Q: std_ulogic; -- /Address Decoding (outputs)/BANK1_1
  signal FF1_Y: std_ulogic; -- /Address Decoding (outputs)/AA14_OUT
  signal FH1_Y: std_ulogic; -- /Address Decoding (outputs)/AA13_OUT
  signal FS1_Y: std_ulogic; -- /Address Decoding (outputs)/RAMG_OK
  signal FV1_Q: std_ulogic; -- /Address Decoding (outputs)/BANK2_0
  signal FX1_Q: std_ulogic; -- /Address Decoding (outputs)/BANK2_1
  signal FY1_Q: std_ulogic; -- /Address Decoding (outputs)/BANK1_2
  signal FZ1_Q: std_ulogic; -- /Address Decoding (outputs)/BANK1_3
  signal GA1_Q: std_ulogic; -- /Address Decoding (outputs)/BANK1_4
  signal GB1_Y: std_ulogic; -- /Address Decoding (outputs)/BANK1_ZERO
  signal GH1_Y: std_ulogic; -- /Address Decoding (outputs)/RA15_OUT
  signal GK1_Y: std_ulogic; -- /Address Decoding (outputs)/RA16_OUT
  signal GM1_Y: std_ulogic; -- /Address Decoding (outputs)/RA17_OUT
  signal GP1_Y: std_ulogic; -- /Address Decoding (outputs)/RA18_OUT
  signal GS1_Y: std_ulogic; -- /Address Decoding (outputs)/~{RAM_CS_OUT}
  signal GT1_Y: std_ulogic; -- /Address Decoding (outputs)/RAM_CS_OUT
  signal GX1_Y: std_ulogic; -- /Address Decoding (outputs)/~{ROM_CS_OUT}
  signal RESET: std_ulogic; -- /RESET
  signal nD0: std_ulogic; -- /~{D0}
  signal nD1: std_ulogic; -- /~{D1}
  signal nD2: std_ulogic; -- /~{D2}
  signal nD3: std_ulogic; -- /~{D3}
  signal nD4: std_ulogic; -- /~{D4}
  signal nRESET_BANK1: std_ulogic; -- /~{RESET_BANK1}
  signal nRESET_MODE_BANK2: std_ulogic; -- /~{RESET_MODE_BANK2}
  signal nRESET_RAMG: std_ulogic; -- /~{RESET_RAMG}
begin
  AG1_inst: OBUF -- AG1
  port map (
    I => EN1_Y,
    OL => AG1_OL,
    nOH => AG1_nOH
  );

  AH1_inst: OBUF -- AH1
  port map (
    I => GH1_Y,
    OL => AH1_OL,
    nOH => AH1_nOH
  );

  AJ1_inst: OBUF -- AJ1
  port map (
    I => GK1_Y,
    OL => AJ1_OL,
    nOH => AJ1_nOH
  );

  AK1_inst: OBUF -- AK1
  port map (
    I => GM1_Y,
    OL => AK1_OL,
    nOH => AK1_nOH
  );

  AL1_inst: OBUF -- AL1
  port map (
    I => GP1_Y,
    OL => AL1_OL,
    nOH => AL1_nOH
  );

  AM1_inst: OBUF -- AM1
  port map (
    I => GX1_Y,
    OL => AM1_OL,
    nOH => AM1_nOH
  );

  Address_Decoding_outputs_inst: output_addr_decoding -- /Address Decoding (outputs)/
  port map (
    AA13_OUT => FH1_Y,
    AA14_OUT => FF1_Y,
    BANK1_0 => FC1_Q,
    BANK1_1 => FD1_Q,
    BANK1_2 => FY1_Q,
    BANK1_3 => FZ1_Q,
    BANK1_4 => GA1_Q,
    BANK1_ZERO => GB1_Y,
    BANK2_0 => FV1_Q,
    BANK2_1 => FX1_Q,
    CS => AA1_Y,
    MODE => EJ1_Q,
    RA14_OUT => EN1_Y,
    RA15_OUT => GH1_Y,
    RA16_OUT => GK1_Y,
    RA17_OUT => GM1_Y,
    RA18_OUT => GP1_Y,
    RAMG_OK => FS1_Y,
    RAM_CS_OUT => GT1_Y,
    RD_OR_RESET => DA1_Y,
    nA14_H => AD1_Y,
    nA15_H => AE1_Y,
    nRAM_CS_OUT => GS1_Y,
    nRESET_RAMG => nRESET_RAMG,
    nROM_CS_OUT => GX1_Y
  );

  Address_Decoding_register_writes_inst: write_addr_decoding -- /Address Decoding (register writes)/
  port map (
    A13_L => AF1_Y,
    A15_L => AC1_Y,
    BANK1_WR => EL1_Y,
    BANK2_WR => EE1_Y,
    MODE_WR => EF1_Y,
    RAMG_WR => EK1_Y,
    WR => AB1_Y,
    nA14_H => AD1_Y
  );

  BANK1_register_0x2000_0x3FFF_inst: bank1_register -- /BANK1 register (0x2000-0x3FFF)/
  port map (
    BANK1_0 => FC1_Q,
    BANK1_1 => FD1_Q,
    BANK1_2 => FY1_Q,
    BANK1_3 => FZ1_Q,
    BANK1_4 => GA1_Q,
    BANK1_ZERO => GB1_Y,
    WR => EL1_Y,
    nD0 => nD0,
    nD1 => nD1,
    nD2 => nD2,
    nD3 => nD3,
    nD4 => nD4,
    nRESET => nRESET_BANK1
  );

  BANK2_register_0x4000_0x5FFF_inst: bank2_register -- /BANK2 register (0x4000-0x5FFF)/
  port map (
    BANK2_0 => FV1_Q,
    BANK2_1 => FX1_Q,
    WR => EE1_Y,
    nD0 => nD0,
    nD1 => nD1,
    nRESET => nRESET_MODE_BANK2
  );

  CD1_inst: OBUF -- CD1
  port map (
    I => FH1_Y,
    OL => CD1_OL,
    nOH => CD1_nOH
  );

  CE1_inst: OBUF -- CE1
  port map (
    I => FF1_Y,
    OL => CE1_OL,
    nOH => CE1_nOH
  );

  CF1_inst: OBUF -- CF1
  port map (
    I => GS1_Y,
    OL => CF1_OL,
    nOH => CF1_nOH
  );

  CG1_inst: OBUF -- CG1
  port map (
    I => GT1_Y,
    OL => CG1_OL,
    nOH => CG1_nOH
  );

  DB1_inst: SCHMITT -- DB1
  port map (
    A => nRESET,
    Y => DB1_Y
  );

  EB1_inst: INV -- EB1
  port map (
    A => RESET,
    Y => nRESET_MODE_BANK2
  );

  ER1_inst: INV -- ER1
  port map (
    A => RESET,
    Y => nRESET_BANK1
  );

  ES1_inst: INV -- ES1
  port map (
    A => RESET,
    Y => nRESET_RAMG
  );

  GY1_inst: INV -- GY1
  port map (
    A => DB1_Y,
    Y => RESET
  );

  Input_Gating_inst: input_gating -- /Input Gating/
  port map (
    A13_IN => A13,
    A13_L => AF1_Y,
    A14_IN => A14,
    A15_IN => A15,
    A15_L => AC1_Y,
    CS => AA1_Y,
    D0_IN => D0,
    D1_IN => D1,
    D2_IN => D2,
    D3_IN => D3,
    D4_IN => D4,
    RD_OR_RESET => DA1_Y,
    RESET => RESET,
    WR => AB1_Y,
    nA14_H => AD1_Y,
    nA15_H => AE1_Y,
    nCS_IN => nCS,
    nD0 => nD0,
    nD1 => nD1,
    nD2 => nD2,
    nD3 => nD3,
    nD4 => nD4,
    nRD_IN => nRD,
    nWR_IN => nWR
  );

  MODE_register_0x6000_0x7FFF_inst: mode_register -- /MODE register (0x6000-0x7FFF)/
  port map (
    MODE => EJ1_Q,
    WR => EF1_Y,
    nD0 => nD0,
    nRESET => nRESET_MODE_BANK2
  );

  RAMG_register_0x0000_0x1FFF_inst: ramg_register -- /RAMG register (0x0000-0x1FFF)/
  port map (
    RAMG_OK => FS1_Y,
    WR => EK1_Y,
    nD0 => nD0,
    nD1 => nD1,
    nD2 => nD2,
    nD3 => nD3,
    nRESET => nRESET_RAMG
  );

  U1_inst: ODRV -- U1
  port map (
    OL => CD1_OL,
    PIN => AA13,
    nOH => CD1_nOH
  );

  U2_inst: ODRV -- U2
  port map (
    OL => CE1_OL,
    PIN => AA14,
    nOH => CE1_nOH
  );

  U3_inst: ODRV -- U3
  port map (
    OL => CF1_OL,
    PIN => nRAM_CS,
    nOH => CF1_nOH
  );

  U4_inst: ODRV -- U4
  port map (
    OL => CG1_OL,
    PIN => RAM_CS,
    nOH => CG1_nOH
  );

  U5_inst: ODRV -- U5
  port map (
    OL => AG1_OL,
    PIN => RA14,
    nOH => AG1_nOH
  );

  U6_inst: ODRV -- U6
  port map (
    OL => AH1_OL,
    PIN => RA15,
    nOH => AH1_nOH
  );

  U7_inst: ODRV -- U7
  port map (
    OL => AJ1_OL,
    PIN => RA16,
    nOH => AJ1_nOH
  );

  U8_inst: ODRV -- U8
  port map (
    OL => AK1_OL,
    PIN => RA17,
    nOH => AK1_nOH
  );

  U9_inst: ODRV -- U9
  port map (
    OL => AL1_OL,
    PIN => RA18,
    nOH => AL1_nOH
  );

  U10_inst: ODRV -- U10
  port map (
    OL => AM1_OL,
    PIN => nROM_CS,
    nOH => AM1_nOH
  );

end architecture;
