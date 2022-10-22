-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83.all;

package sm83_alu is
  type alu_stage1_in is record
    half_carry: std_ulogic;
    carry: std_ulogic;
    zero: std_ulogic;
    a_reg_hi_9bdf: std_ulogic;
    a_reg_lo_gt_9: std_ulogic;
    a_reg_hi_gt_9: std_ulogic;
  end record;

  type alu_stage1_out is record
    data_nand: std_ulogic_vector(7 downto 0);
    data_generate: std_ulogic_vector(7 downto 0);
    data_propagate: std_ulogic_vector(7 downto 0);
    data_logic: std_ulogic_vector(7 downto 0);
    cc_match: std_ulogic;
    carry_in: std_ulogic;
    z_reg_sign: std_ulogic;
    flags: cpu_flags;
  end record;

  type alu_stage2_in is record
    data_nand: std_ulogic_vector(7 downto 0);
    data_generate: std_ulogic_vector(7 downto 0);
    data_propagate: std_ulogic_vector(7 downto 0);
    data_logic: std_ulogic_vector(7 downto 0);
    carry: std_ulogic;
  end record;

  type alu_stage2_out is record
    data: std_ulogic_vector(7 downto 0);
    zero: std_ulogic;
    half_carry: std_ulogic;
    carry: std_ulogic;
  end record;

  type alu_out is record
    data: std_ulogic_vector(7 downto 0);
    flags: cpu_flags;
  end record;
end package;
