library ieee;
use ieee.std_logic_1164.all;

use work.cells.all;
use work.modules.all;

entity MBC1B is
  port (
    A13: in std_ulogic;
    A14: in std_ulogic;
    A15: in std_ulogic;
    D0: in std_ulogic;
    D1: in std_ulogic;
    D2: in std_ulogic;
    D3: in std_ulogic;
    D4: in std_ulogic;
    nCS: in std_ulogic;
    nRD: in std_ulogic;
    nRESET: in std_ulogic;
    nWR: in std_ulogic;
    AA13: out std_ulogic;
    AA14: out std_ulogic;
    RA14: out std_ulogic;
    RA15: out std_ulogic;
    RA16: out std_ulogic;
    RA17: out std_ulogic;
    RA18: out std_ulogic;
    RAM_CS: out std_ulogic;
    nRAM_CS: out std_ulogic;
    nROM_CS: out std_ulogic
  );
end entity;

architecture kingfish of MBC1B is
  signal AG1_OL: std_ulogic;
  signal AG1_nOH: std_ulogic;
  signal AH1_OL: std_ulogic;
  signal AH1_nOH: std_ulogic;
  signal AJ1_OL: std_ulogic;
  signal AJ1_nOH: std_ulogic;
  signal AK1_OL: std_ulogic;
  signal AK1_nOH: std_ulogic;
  signal AL1_OL: std_ulogic;
  signal AL1_nOH: std_ulogic;
  signal AM1_OL: std_ulogic;
  signal AM1_nOH: std_ulogic;
  signal BANK1_REGISTER_BANK1: std_ulogic_vector(4 downto 0);
  signal BANK1_REGISTER_BANK1_ZERO: std_ulogic;
  signal BANK2_REGISTER_BANK2: std_ulogic_vector(1 downto 0);
  signal CD1_OL: std_ulogic;
  signal CD1_nOH: std_ulogic;
  signal CE1_OL: std_ulogic;
  signal CE1_nOH: std_ulogic;
  signal CF1_OL: std_ulogic;
  signal CF1_nOH: std_ulogic;
  signal CG1_OL: std_ulogic;
  signal CG1_nOH: std_ulogic;
  signal DB1_Y: std_ulogic;
  signal INPUT_GATING_A13_L: std_ulogic;
  signal INPUT_GATING_A15_L: std_ulogic;
  signal INPUT_GATING_CS: std_ulogic;
  signal INPUT_GATING_RD_OR_RESET: std_ulogic;
  signal INPUT_GATING_WR: std_ulogic;
  signal INPUT_GATING_nA14_H: std_ulogic;
  signal INPUT_GATING_nA15_H: std_ulogic;
  signal MODE_REGISTER_MODE: std_ulogic;
  signal OUTPUT_ADDR_DECODING_AA13_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_AA14_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_RA14_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_RA15_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_RA16_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_RA17_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_RA18_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_RAM_CS_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_nRAM_CS_OUT: std_ulogic;
  signal OUTPUT_ADDR_DECODING_nROM_CS_OUT: std_ulogic;
  signal RAMG_REGISTER_RAMG_OK: std_ulogic;
  signal RESET: std_ulogic;
  signal WRITE_ADDR_DECODING_BANK1_WR: std_ulogic;
  signal WRITE_ADDR_DECODING_BANK2_WR: std_ulogic;
  signal WRITE_ADDR_DECODING_MODE_WR: std_ulogic;
  signal WRITE_ADDR_DECODING_RAMG_WR: std_ulogic;
  signal nD: std_ulogic_vector(4 downto 0);
  signal nRESET_BANK1: std_ulogic;
  signal nRESET_MODE_BANK2: std_ulogic;
  signal nRESET_RAMG: std_ulogic;
begin
  inst_AG1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_RA14_OUT,
    OL => AG1_OL,
    nOH => AG1_nOH
  );

  inst_AH1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_RA15_OUT,
    OL => AH1_OL,
    nOH => AH1_nOH
  );

  inst_AJ1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_RA16_OUT,
    OL => AJ1_OL,
    nOH => AJ1_nOH
  );

  inst_AK1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_RA17_OUT,
    OL => AK1_OL,
    nOH => AK1_nOH
  );

  inst_AL1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_RA18_OUT,
    OL => AL1_OL,
    nOH => AL1_nOH
  );

  inst_AM1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_nROM_CS_OUT,
    OL => AM1_OL,
    nOH => AM1_nOH
  );

  inst_CD1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_AA13_OUT,
    OL => CD1_OL,
    nOH => CD1_nOH
  );

  inst_CE1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_AA14_OUT,
    OL => CE1_OL,
    nOH => CE1_nOH
  );

  inst_CF1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_nRAM_CS_OUT,
    OL => CF1_OL,
    nOH => CF1_nOH
  );

  inst_CG1: OBUF
  port map (
    I => OUTPUT_ADDR_DECODING_RAM_CS_OUT,
    OL => CG1_OL,
    nOH => CG1_nOH
  );

  inst_DB1: SCHMITT
  port map (
    A => nRESET,
    Y => DB1_Y
  );

  inst_EB1: INV
  port map (
    A => RESET,
    Y => nRESET_MODE_BANK2
  );

  inst_ER1: INV
  port map (
    A => RESET,
    Y => nRESET_BANK1
  );

  inst_ES1: INV
  port map (
    A => RESET,
    Y => nRESET_RAMG
  );

  inst_GY1: INV
  port map (
    A => DB1_Y,
    Y => RESET
  );

  inst_U1: ODRV
  port map (
    OL => CD1_OL,
    PIN => AA13,
    nOH => CD1_nOH
  );

  inst_U2: ODRV
  port map (
    OL => CE1_OL,
    PIN => AA14,
    nOH => CE1_nOH
  );

  inst_U3: ODRV
  port map (
    OL => CF1_OL,
    PIN => nRAM_CS,
    nOH => CF1_nOH
  );

  inst_U4: ODRV
  port map (
    OL => CG1_OL,
    PIN => RAM_CS,
    nOH => CG1_nOH
  );

  inst_U5: ODRV
  port map (
    OL => AG1_OL,
    PIN => RA14,
    nOH => AG1_nOH
  );

  inst_U6: ODRV
  port map (
    OL => AH1_OL,
    PIN => RA15,
    nOH => AH1_nOH
  );

  inst_U7: ODRV
  port map (
    OL => AJ1_OL,
    PIN => RA16,
    nOH => AJ1_nOH
  );

  inst_U8: ODRV
  port map (
    OL => AK1_OL,
    PIN => RA17,
    nOH => AK1_nOH
  );

  inst_U9: ODRV
  port map (
    OL => AL1_OL,
    PIN => RA18,
    nOH => AL1_nOH
  );

  inst_U10: ODRV
  port map (
    OL => AM1_OL,
    PIN => nROM_CS,
    nOH => AM1_nOH
  );

  inst_bank1_register: bank1_register -- BANK1 register (0x2000-0x3FFF)
  port map (
    BANK1 => BANK1_REGISTER_BANK1(4 downto 0),
    BANK1_ZERO => BANK1_REGISTER_BANK1_ZERO,
    WR => WRITE_ADDR_DECODING_BANK1_WR,
    nD => nD(4 downto 0),
    nRESET => nRESET_BANK1
  );

  inst_bank2_register: bank2_register -- BANK2 register (0x4000-0x5FFF)
  port map (
    BANK2 => BANK2_REGISTER_BANK2(1 downto 0),
    WR => WRITE_ADDR_DECODING_BANK2_WR,
    nD => nD(1 downto 0),
    nRESET => nRESET_MODE_BANK2
  );

  inst_input_gating: input_gating -- Input Gating
  port map (
    A13_IN => A13,
    A13_L => INPUT_GATING_A13_L,
    A14_IN => A14,
    A15_IN => A15,
    A15_L => INPUT_GATING_A15_L,
    CS => INPUT_GATING_CS,
    D0_IN => D0,
    D1_IN => D1,
    D2_IN => D2,
    D3_IN => D3,
    D4_IN => D4,
    RD_OR_RESET => INPUT_GATING_RD_OR_RESET,
    RESET => RESET,
    WR => INPUT_GATING_WR,
    nA14_H => INPUT_GATING_nA14_H,
    nA15_H => INPUT_GATING_nA15_H,
    nCS_IN => nCS,
    nD0 => nD(0),
    nD1 => nD(1),
    nD2 => nD(2),
    nD3 => nD(3),
    nD4 => nD(4),
    nRD_IN => nRD,
    nWR_IN => nWR
  );

  inst_mode_register: mode_register -- MODE register (0x6000-0x7FFF)
  port map (
    MODE => MODE_REGISTER_MODE,
    WR => WRITE_ADDR_DECODING_MODE_WR,
    nD0 => nD(0),
    nRESET => nRESET_MODE_BANK2
  );

  inst_output_addr_decoding: output_addr_decoding -- Address Decoding (outputs)
  port map (
    AA13_OUT => OUTPUT_ADDR_DECODING_AA13_OUT,
    AA14_OUT => OUTPUT_ADDR_DECODING_AA14_OUT,
    BANK1 => BANK1_REGISTER_BANK1(4 downto 0),
    BANK1_ZERO => BANK1_REGISTER_BANK1_ZERO,
    BANK2 => BANK2_REGISTER_BANK2(1 downto 0),
    CS => INPUT_GATING_CS,
    MODE => MODE_REGISTER_MODE,
    RA14_OUT => OUTPUT_ADDR_DECODING_RA14_OUT,
    RA15_OUT => OUTPUT_ADDR_DECODING_RA15_OUT,
    RA16_OUT => OUTPUT_ADDR_DECODING_RA16_OUT,
    RA17_OUT => OUTPUT_ADDR_DECODING_RA17_OUT,
    RA18_OUT => OUTPUT_ADDR_DECODING_RA18_OUT,
    RAMG_OK => RAMG_REGISTER_RAMG_OK,
    RAM_CS_OUT => OUTPUT_ADDR_DECODING_RAM_CS_OUT,
    RD_OR_RESET => INPUT_GATING_RD_OR_RESET,
    nA14_H => INPUT_GATING_nA14_H,
    nA15_H => INPUT_GATING_nA15_H,
    nRAM_CS_OUT => OUTPUT_ADDR_DECODING_nRAM_CS_OUT,
    nRESET_RAMG => nRESET_RAMG,
    nROM_CS_OUT => OUTPUT_ADDR_DECODING_nROM_CS_OUT
  );

  inst_ramg_register: ramg_register -- RAMG register (0x0000-0x1FFF)
  port map (
    RAMG_OK => RAMG_REGISTER_RAMG_OK,
    WR => WRITE_ADDR_DECODING_RAMG_WR,
    nD => nD(3 downto 0),
    nRESET => nRESET_RAMG
  );

  inst_write_addr_decoding: write_addr_decoding -- Address Decoding (register writes)
  port map (
    A13_L => INPUT_GATING_A13_L,
    A15_L => INPUT_GATING_A15_L,
    BANK1_WR => WRITE_ADDR_DECODING_BANK1_WR,
    BANK2_WR => WRITE_ADDR_DECODING_BANK2_WR,
    MODE_WR => WRITE_ADDR_DECODING_MODE_WR,
    RAMG_WR => WRITE_ADDR_DECODING_RAMG_WR,
    WR => INPUT_GATING_WR,
    nA14_H => INPUT_GATING_nA14_H
  );

end architecture;
