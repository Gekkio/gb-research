library ieee;
use ieee.std_logic_1164.all;

package modules is
  component MBC1B is
    port (
      A13: in std_ulogic; -- /A13
      A14: in std_ulogic; -- /A14
      A15: in std_ulogic; -- /A15
      AA13: out std_ulogic; -- /AA13
      AA14: out std_ulogic; -- /AA14
      D0: in std_ulogic; -- /D0
      D1: in std_ulogic; -- /D1
      D2: in std_ulogic; -- /D2
      D3: in std_ulogic; -- /D3
      D4: in std_ulogic; -- /D4
      RA14: out std_ulogic; -- /RA14
      RA15: out std_ulogic; -- /RA15
      RA16: out std_ulogic; -- /RA16
      RA17: out std_ulogic; -- /RA17
      RA18: out std_ulogic; -- /RA18
      RAM_CS: out std_ulogic; -- /RAM_CS
      nCS: in std_ulogic; -- /~{CS}
      nRAM_CS: out std_ulogic; -- /~{RAM_CS}
      nRD: in std_ulogic; -- /~{RD}
      nRESET: in std_ulogic; -- /~{RESET}
      nROM_CS: out std_ulogic; -- /~{ROM_CS}
      nWR: in std_ulogic -- /~{WR}
    );
  end component;

  component bank1_register is
    port (
      BANK1_0: out std_ulogic; -- /Address Decoding (outputs)/BANK1_0
      BANK1_1: out std_ulogic; -- /Address Decoding (outputs)/BANK1_1
      BANK1_2: out std_ulogic; -- /Address Decoding (outputs)/BANK1_2
      BANK1_3: out std_ulogic; -- /Address Decoding (outputs)/BANK1_3
      BANK1_4: out std_ulogic; -- /Address Decoding (outputs)/BANK1_4
      BANK1_ZERO: out std_ulogic; -- /Address Decoding (outputs)/BANK1_ZERO
      WR: in std_ulogic; -- /Address Decoding (register writes)/BANK1_WR
      nD0: in std_ulogic; -- /~{D0}
      nD1: in std_ulogic; -- /~{D1}
      nD2: in std_ulogic; -- /~{D2}
      nD3: in std_ulogic; -- /~{D3}
      nD4: in std_ulogic; -- /~{D4}
      nRESET: in std_ulogic -- /~{RESET_BANK1}
    );
  end component;

  component bank2_register is
    port (
      BANK2_0: out std_ulogic; -- /Address Decoding (outputs)/BANK2_0
      BANK2_1: out std_ulogic; -- /Address Decoding (outputs)/BANK2_1
      WR: in std_ulogic; -- /Address Decoding (register writes)/BANK2_WR
      nD0: in std_ulogic; -- /~{D0}
      nD1: in std_ulogic; -- /~{D1}
      nRESET: in std_ulogic -- /~{RESET_MODE_BANK2}
    );
  end component;

  component input_gating is
    port (
      A13_IN: in std_ulogic; -- /A13
      A13_L: out std_ulogic; -- /Address Decoding (register writes)/A13_L
      A14_IN: in std_ulogic; -- /A14
      A15_IN: in std_ulogic; -- /A15
      A15_L: out std_ulogic; -- /Address Decoding (register writes)/A15_L
      CS: out std_ulogic; -- /Address Decoding (outputs)/CS
      D0_IN: in std_ulogic; -- /D0
      D1_IN: in std_ulogic; -- /D1
      D2_IN: in std_ulogic; -- /D2
      D3_IN: in std_ulogic; -- /D3
      D4_IN: in std_ulogic; -- /D4
      RD_OR_RESET: out std_ulogic; -- /Address Decoding (outputs)/RD_OR_RESET
      RESET: in std_ulogic; -- /RESET
      WR: out std_ulogic; -- /Address Decoding (register writes)/WR
      nA14_H: out std_ulogic; -- /Address Decoding (outputs)/~{A14_H}
      nA15_H: out std_ulogic; -- /Address Decoding (outputs)/~{A15_H}
      nCS_IN: in std_ulogic; -- /~{CS}
      nD0: out std_ulogic; -- /~{D0}
      nD1: out std_ulogic; -- /~{D1}
      nD2: out std_ulogic; -- /~{D2}
      nD3: out std_ulogic; -- /~{D3}
      nD4: out std_ulogic; -- /~{D4}
      nRD_IN: in std_ulogic; -- /~{RD}
      nWR_IN: in std_ulogic -- /~{WR}
    );
  end component;

  component mode_register is
    port (
      MODE: out std_ulogic; -- /Address Decoding (outputs)/MODE
      WR: in std_ulogic; -- /Address Decoding (register writes)/MODE_WR
      nD0: in std_ulogic; -- /~{D0}
      nRESET: in std_ulogic -- /~{RESET_MODE_BANK2}
    );
  end component;

  component output_addr_decoding is
    port (
      AA13_OUT: out std_ulogic; -- /Address Decoding (outputs)/AA13_OUT
      AA14_OUT: out std_ulogic; -- /Address Decoding (outputs)/AA14_OUT
      BANK1_0: in std_ulogic; -- /Address Decoding (outputs)/BANK1_0
      BANK1_1: in std_ulogic; -- /Address Decoding (outputs)/BANK1_1
      BANK1_2: in std_ulogic; -- /Address Decoding (outputs)/BANK1_2
      BANK1_3: in std_ulogic; -- /Address Decoding (outputs)/BANK1_3
      BANK1_4: in std_ulogic; -- /Address Decoding (outputs)/BANK1_4
      BANK1_ZERO: in std_ulogic; -- /Address Decoding (outputs)/BANK1_ZERO
      BANK2_0: in std_ulogic; -- /Address Decoding (outputs)/BANK2_0
      BANK2_1: in std_ulogic; -- /Address Decoding (outputs)/BANK2_1
      CS: in std_ulogic; -- /Address Decoding (outputs)/CS
      MODE: in std_ulogic; -- /Address Decoding (outputs)/MODE
      RA14_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA14_OUT
      RA15_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA15_OUT
      RA16_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA16_OUT
      RA17_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA17_OUT
      RA18_OUT: out std_ulogic; -- /Address Decoding (outputs)/RA18_OUT
      RAMG_OK: in std_ulogic; -- /Address Decoding (outputs)/RAMG_OK
      RAM_CS_OUT: out std_ulogic; -- /Address Decoding (outputs)/RAM_CS_OUT
      RD_OR_RESET: in std_ulogic; -- /Address Decoding (outputs)/RD_OR_RESET
      nA14_H: in std_ulogic; -- /Address Decoding (outputs)/~{A14_H}
      nA15_H: in std_ulogic; -- /Address Decoding (outputs)/~{A15_H}
      nRAM_CS_OUT: out std_ulogic; -- /Address Decoding (outputs)/~{RAM_CS_OUT}
      nRESET_RAMG: in std_ulogic; -- /~{RESET_RAMG}
      nROM_CS_OUT: out std_ulogic -- /Address Decoding (outputs)/~{ROM_CS_OUT}
    );
  end component;

  component ramg_register is
    port (
      RAMG_OK: out std_ulogic; -- /Address Decoding (outputs)/RAMG_OK
      WR: in std_ulogic; -- /Address Decoding (register writes)/RAMG_WR
      nD0: in std_ulogic; -- /~{D0}
      nD1: in std_ulogic; -- /~{D1}
      nD2: in std_ulogic; -- /~{D2}
      nD3: in std_ulogic; -- /~{D3}
      nRESET: in std_ulogic -- /~{RESET_RAMG}
    );
  end component;

  component write_addr_decoding is
    port (
      A13_L: in std_ulogic; -- /Address Decoding (register writes)/A13_L
      A15_L: in std_ulogic; -- /Address Decoding (register writes)/A15_L
      BANK1_WR: out std_ulogic; -- /Address Decoding (register writes)/BANK1_WR
      BANK2_WR: out std_ulogic; -- /Address Decoding (register writes)/BANK2_WR
      MODE_WR: out std_ulogic; -- /Address Decoding (register writes)/MODE_WR
      RAMG_WR: out std_ulogic; -- /Address Decoding (register writes)/RAMG_WR
      WR: in std_ulogic; -- /Address Decoding (register writes)/WR
      nA14_H: in std_ulogic -- /Address Decoding (outputs)/~{A14_H}
    );
  end component;


end package;
