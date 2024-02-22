-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83_decoder.all;

-- Instruction decoder
entity decoder is
  port (
    clk: in std_ulogic;
    phi: in std_ulogic;
    writeback: in std_ulogic;
    intr: in std_ulogic;
    cb_mode: in std_ulogic;
    ir_reg: in std_ulogic_vector(7 downto 0);
    state: in std_ulogic_vector(2 downto 0);
    data_lsb: in std_ulogic;
    outputs: out decoder_type
  );
end entity;

architecture asic of decoder is
  signal stage1: decoder_stage1_type;
  signal stage2: decoder_stage2_type;
  signal stage3: decoder_stage3_type;
begin
  stage1_inst: entity work.decoder_stage1
  port map (
    clk => clk,
    intr => intr,
    cb_mode => cb_mode,
    ir_reg => ir_reg,
    state => state,
    outputs => stage1
  );

  stage2_inst: entity work.decoder_stage2
  port map (
    clk => clk,
    stage1 => stage1,
    outputs => stage2
  );

  stage3_inst: entity work.decoder_stage3
  port map (
    clk => clk,
    phi => phi,
    writeback => writeback,
    cb_mode => cb_mode,
    ir_reg => ir_reg,
    data_lsb => data_lsb,
    stage1 => stage1,
    stage2 => stage2,
    outputs => stage3
  );

  process(all)
  begin
    outputs <= to_decoder_type(stage1, stage2, stage3);
  end process;
end architecture;
