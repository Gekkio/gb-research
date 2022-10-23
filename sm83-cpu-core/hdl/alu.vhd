-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83.all;
use work.sm83_alu.all;
use work.sm83_decoder.all;

-- Arithmetic and Logic Unit (ALU)
entity alu is
  port (
    clk: in std_ulogic;
    phi: in std_ulogic;
    writeback: in std_ulogic;
    writeback_ext: in std_ulogic;
    decoder: in decoder_type;
    a_reg_hi_9bdf: in std_ulogic;
    a_reg_lo_gt_9: in std_ulogic;
    a_reg_hi_gt_9: in std_ulogic;
    cc_match: out std_ulogic;
    z_reg_sign: out std_ulogic;
    carry: out std_ulogic;
    flags: out cpu_flags;
    ir_reg: in std_ulogic_vector(7 downto 0);
    z_reg: in std_ulogic_vector(7 downto 4);
    q_bus: in std_ulogic_vector(7 downto 0);
    r_bus: in std_ulogic_vector(7 downto 0);
    data_out: out std_ulogic_vector(7 downto 0)
  );
end entity;

architecture asic of alu is
  signal stage1_in: alu_stage1_in;
  signal stage1_out: alu_stage1_out;
  signal stage2_in: alu_stage2_in;
  signal stage2_out: alu_stage2_out;
begin
  stage1_in.half_carry <= stage2_out.half_carry;
  stage1_in.carry <= stage2_out.carry;
  stage1_in.zero <= stage2_out.zero;
  stage1_in.a_reg_hi_9bdf <= a_reg_hi_9bdf;
  stage1_in.a_reg_lo_gt_9 <= a_reg_lo_gt_9;
  stage1_in.a_reg_hi_gt_9 <= a_reg_hi_gt_9;

  stage1: entity work.alu_stage1
  port map (
    clk => clk,
    phi => phi,
    writeback => writeback,
    writeback_ext => writeback_ext,
    decoder => decoder,
    q_bus => q_bus,
    r_bus => r_bus,
    ir_reg => ir_reg,
    z_reg => z_reg,
    inputs => stage1_in,
    outputs => stage1_out
  );

  cc_match <= stage1_out.cc_match;
  z_reg_sign <= stage1_out.z_reg_sign;
  flags <= stage1_out.flags;

  stage2_in.data_nand <= stage1_out.data_nand;
  stage2_in.data_generate <= stage1_out.data_generate;
  stage2_in.data_propagate <= stage1_out.data_propagate;
  stage2_in.data_logic <= stage1_out.data_logic;
  stage2_in.carry <= stage1_out.carry_in;

  stage2: entity work.alu_stage2
  port map (
    decoder => decoder,
    inputs => stage2_in,
    outputs => stage2_out
  );

  carry <= stage2_out.carry;
  data_out <= stage2_out.data;
end architecture;
