library ieee;
use ieee.std_logic_1164.all;

package modules is
  component MBC1B is
    port (
      A13: in std_ulogic;
      A14: in std_ulogic;
      A15: in std_ulogic;
      AA13: out std_ulogic;
      AA14: out std_ulogic;
      D0: in std_ulogic;
      D1: in std_ulogic;
      D2: in std_ulogic;
      D3: in std_ulogic;
      D4: in std_ulogic;
      RA14: out std_ulogic;
      RA15: out std_ulogic;
      RA16: out std_ulogic;
      RA17: out std_ulogic;
      RA18: out std_ulogic;
      RAM_CS: out std_ulogic;
      nCS: in std_ulogic;
      nRAM_CS: out std_ulogic;
      nRD: in std_ulogic;
      nRESET: in std_ulogic;
      nROM_CS: out std_ulogic;
      nWR: in std_ulogic
    );
  end component;

  component bank1_register is
    port (
      BANK1: out std_ulogic_vector(4 downto 0);
      BANK1_ZERO: out std_ulogic;
      WR: in std_ulogic;
      nD: in std_ulogic_vector(4 downto 0);
      nRESET: in std_ulogic
    );
  end component;

  component bank2_register is
    port (
      BANK2: out std_ulogic_vector(1 downto 0);
      WR: in std_ulogic;
      nD: in std_ulogic_vector(1 downto 0);
      nRESET: in std_ulogic
    );
  end component;

  component input_gating is
    port (
      A13_IN: in std_ulogic;
      A13_L: out std_ulogic;
      A14_IN: in std_ulogic;
      A15_IN: in std_ulogic;
      A15_L: out std_ulogic;
      CS: out std_ulogic;
      D0_IN: in std_ulogic;
      D1_IN: in std_ulogic;
      D2_IN: in std_ulogic;
      D3_IN: in std_ulogic;
      D4_IN: in std_ulogic;
      RD_OR_RESET: out std_ulogic;
      RESET: in std_ulogic;
      WR: out std_ulogic;
      nA14_H: out std_ulogic;
      nA15_H: out std_ulogic;
      nCS_IN: in std_ulogic;
      nD0: out std_ulogic;
      nD1: out std_ulogic;
      nD2: out std_ulogic;
      nD3: out std_ulogic;
      nD4: out std_ulogic;
      nRD_IN: in std_ulogic;
      nWR_IN: in std_ulogic
    );
  end component;

  component mode_register is
    port (
      MODE: out std_ulogic;
      WR: in std_ulogic;
      nD0: in std_ulogic;
      nRESET: in std_ulogic
    );
  end component;

  component output_addr_decoding is
    port (
      AA13_OUT: out std_ulogic;
      AA14_OUT: out std_ulogic;
      BANK1: in std_ulogic_vector(4 downto 0);
      BANK1_ZERO: in std_ulogic;
      BANK2: in std_ulogic_vector(1 downto 0);
      CS: in std_ulogic;
      MODE: in std_ulogic;
      RA14_OUT: out std_ulogic;
      RA15_OUT: out std_ulogic;
      RA16_OUT: out std_ulogic;
      RA17_OUT: out std_ulogic;
      RA18_OUT: out std_ulogic;
      RAMG_OK: in std_ulogic;
      RAM_CS_OUT: out std_ulogic;
      RD_OR_RESET: in std_ulogic;
      nA14_H: in std_ulogic;
      nA15_H: in std_ulogic;
      nRAM_CS_OUT: out std_ulogic;
      nRESET_RAMG: in std_ulogic;
      nROM_CS_OUT: out std_ulogic
    );
  end component;

  component ramg_register is
    port (
      RAMG_OK: out std_ulogic;
      WR: in std_ulogic;
      nD: in std_ulogic_vector(3 downto 0);
      nRESET: in std_ulogic
    );
  end component;

  component write_addr_decoding is
    port (
      A13_L: in std_ulogic;
      A15_L: in std_ulogic;
      BANK1_WR: out std_ulogic;
      BANK2_WR: out std_ulogic;
      MODE_WR: out std_ulogic;
      RAMG_WR: out std_ulogic;
      WR: in std_ulogic;
      nA14_H: in std_ulogic
    );
  end component;


end package;
