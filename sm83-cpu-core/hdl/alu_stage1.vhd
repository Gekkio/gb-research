-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83.all;
use work.sm83_alu.all;
use work.sm83_decoder.all;

-- ALU stage 1 (control, state)
entity alu_stage1 is
  port (
    clk: in std_ulogic;
    phi: in std_ulogic;
    writeback: in std_ulogic;
    writeback_ext: in std_ulogic;
    decoder: in decoder_type;
    q_bus: in std_ulogic_vector(7 downto 0);
    r_bus: in std_ulogic_vector(7 downto 0);
    ir_reg: in std_ulogic_vector(7 downto 0);
    z_reg: in std_ulogic_vector(7 downto 4);
    inputs: in alu_stage1_in;
    outputs: out alu_stage1_out
  );
end entity;

architecture asic of alu_stage1 is
  signal cf: std_ulogic;
  signal zf: std_ulogic;
  signal nf: std_ulogic;
  signal hf: std_ulogic;

  signal cf_next: std_ulogic;
  signal zf_next: std_ulogic;
  signal nf_next: std_ulogic;
  signal hf_next: std_ulogic;

  signal operand_a: std_ulogic_vector(7 downto 0);
  signal operand_b: std_ulogic_vector(7 downto 0);
  signal shifted: std_ulogic_vector(7 downto 0);
  signal data_and: std_ulogic_vector(7 downto 0);
  signal data_or: std_ulogic_vector(7 downto 0);
begin
  operand_a(0) <= (
    q_bus(0) or
    (decoder.alu_res and (ir_reg(5) ?= '1' or ir_reg(4) ?= '1' or ir_reg(3) ?= '1')) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "000")
  ) when clk else '0';

  hf_next <= (
    decoder.alu_logic_and or
    decoder.cb_bit or
    (decoder.op_pop_sx10 and z_reg(5)) or
    decoder.alu_cpl or
    (decoder.alu_sum_neg_hf_nf and not inputs.half_carry) or
    (
      (
        decoder.alu_sum_pos_hf_cf or
        (decoder.op_incdec8 and ir_reg(0) ?= '0') -- INC only
      ) and inputs.half_carry ?= '1'
    )
  ) when writeback else '0'; -- TODO: non-symmetrical clock and writeback_ext

  cf_next <= (
    (decoder.alu_rotate_shift_right and operand_b(0)) or
    (decoder.op_pop_sx10 and z_reg(4)) or
    (decoder.alu_ccf_scf and ir_reg(3) ?= '0') or -- SCF only
    (decoder.alu_ccf_scf and ir_reg(3) ?= '1' and not cf) or -- CCF only
    (decoder.alu_sum_pos_hf_cf and inputs.carry) or
    (decoder.alu_sum_neg_cf and not inputs.carry) or
    (decoder.alu_rotate_shift_left and operand_b(7)) or
    (decoder.alu_cpl and cf) or
    (decoder.alu_daa and (
      cf or (not nf and inputs.carry)
    ))
  ) when writeback else '0'; -- TODO: non-symmetrical clock and writeback_ext

  operand_a(1) <= (
    q_bus(1) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "001") or
    (decoder.alu_res and (ir_reg(5) ?= '1' or ir_reg(4) ?= '1' or ir_reg(3) ?= '0')) or
    (decoder.alu_daa and (
      (hf or (not nf and inputs.a_reg_lo_gt_9))
    ))
  ) when clk else '0';

  operand_a(2) <= (
    q_bus(2) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "010") or
    (decoder.alu_res and (ir_reg(5) ?= '1' or ir_reg(4) ?= '0' or ir_reg(3) ?= '1')) or
    (decoder.alu_daa and (
      (not nf and (hf or inputs.a_reg_lo_gt_9))
    ))
  ) when clk else '0';

  operand_a(3) <= (
    q_bus(3) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "011") or
    (decoder.alu_res and (ir_reg(5) ?= '1' or ir_reg(4) ?= '0' or ir_reg(3) ?= '0')) or
    (decoder.alu_daa and (
      (hf and nf)
    ))
  ) when clk else '0';

  operand_a(4) <= (
    q_bus(4) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "100") or
    (decoder.alu_res and (ir_reg(5) ?= '0' or ir_reg(4) ?= '1' or ir_reg(3) ?= '1')) or
    (decoder.alu_daa and (
      (hf and nf)
    ))
  ) when clk else '0';

  nf_next <= (
    (decoder.alu_daa and nf) or
    decoder.alu_sum_neg_hf_nf or
    decoder.alu_cpl or
    (decoder.op_pop_sx10 and z_reg(6))
  ) when writeback else '0'; -- TODO: non-symmetrical clock and writeback_ext

  operand_a(5) <= (
    q_bus(5) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "101") or
    (decoder.alu_res and (ir_reg(5) ?= '0' or ir_reg(4) ?= '1' or ir_reg(3) ?= '0')) or
    (decoder.alu_daa and (
      (nf and ((cf and not hf) or (hf and not cf))) or
      (not nf and (inputs.a_reg_hi_gt_9 or cf or (inputs.a_reg_lo_gt_9 and inputs.a_reg_hi_9bdf)))
    ))
  ) when clk else '0';

  operand_a(6) <= (
    q_bus(6) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "110") or
    (decoder.alu_res and (ir_reg(5) ?= '0' or ir_reg(4) ?= '0' or ir_reg(3) ?= '1')) or
    (decoder.alu_daa and (
      (hf and nf and not cf) or
      (not nf and ((inputs.a_reg_hi_9bdf and inputs.a_reg_lo_gt_9) or cf or inputs.a_reg_hi_gt_9))
    ))
  ) when clk else '0';

  operand_a(7) <= (
    q_bus(7) or
    (decoder.alu_set and ir_reg(5 downto 3) ?= "111") or
    (decoder.alu_res and (ir_reg(5) ?= '0' or ir_reg(4) ?= '0' or ir_reg(3) ?= '0')) or
    (decoder.alu_daa and (
      (nf and (hf or cf))
    ))
  ) when clk else '0';

  outputs.cc_match <= (
    (
      (cf and ir_reg(4 downto 3) ?= "10") or
      (not cf and ir_reg(4 downto 3) ?= "11") or
      (not zf and ir_reg(4 downto 3) ?= "01") or
      (zf and ir_reg(4 downto 3) ?= "00")
    ) and decoder.cc_check
  ) when writeback else '0';

  zf_next <= (
    -- BIT opcodes set ZF based on one individual bit
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "000" and operand_b(0)) or
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "001" and operand_b(1)) or
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "010" and operand_b(2)) or
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "011" and operand_b(3)) or
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "100" and operand_b(4)) or
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "101" and operand_b(5)) or
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "110" and operand_b(6)) or
    (decoder.cb_bit and ir_reg(5 downto 3) ?= "111" and operand_b(7)) or
    -- ALU operations that set ZF based on the result
    (
      (
        decoder.cb_00_to_3f or
        decoder.op_alu8 or
        decoder.op_incdec8 or
        decoder.alu_daa
      ) and inputs.zero
    ) or
    -- POP AF sets all flags
    (decoder.op_pop_sx10 and z_reg(7)) or
    -- ALU operations that retain old ZF
    (
      (
        decoder.alu_cpl or
        decoder.op_add_hl_sxx0 or
        decoder.alu_ccf_scf or
        decoder.op_add_hl_sx01
      ) and zf
    )
  ) when writeback else '0'; -- TODO: non-symmetrical clock and writeback_ext

  outputs.carry_in <= (
    (decoder.alu_add_adc and ir_reg(3) ?= '1' and cf) or -- ADC only
    (decoder.op_add_hl_sx01 and cf) or
    (decoder.alu_sub_sbc and not cf) or
    (decoder.alu_sub_sbc and ir_reg(3) ?= '0') or -- SUB only
    (decoder.op_sp_e_sx10 and cf) or
    decoder.alu_cp or
    (decoder.op_incdec8 and ir_reg(0) ?= '0') -- INC only
  ) when clk else '0';

  shifted(0) <= (
    (decoder.alu_rlc and r_bus(7)) or
    (decoder.alu_rotate_shift_right and r_bus(1)) or
    (decoder.alu_swap and r_bus(4)) or
    (decoder.alu_rl and cf)
  ) when clk else '0';

  shifted(1) <= (
    (decoder.alu_rotate_shift_left and r_bus(0)) or
    (decoder.alu_rotate_shift_right and r_bus(2)) or
    (decoder.alu_swap and r_bus(5))
  ) when clk else '0';

  shifted(2) <= (
    (decoder.alu_rotate_shift_left and r_bus(1)) or
    (decoder.alu_rotate_shift_right and r_bus(3)) or
    (decoder.alu_swap and r_bus(6))
  ) when clk else '0';

  shifted(3) <= (
    (decoder.alu_rotate_shift_left and r_bus(2)) or
    (decoder.alu_rotate_shift_right and r_bus(4)) or
    (decoder.alu_swap and r_bus(7))
  ) when clk else '0';

  shifted(4) <= (
    (decoder.alu_rotate_shift_right and r_bus(5)) or
    (decoder.alu_rotate_shift_left and r_bus(3)) or
    (decoder.alu_swap and r_bus(0))
  ) when clk else '0';

  shifted(5) <= (
    (decoder.alu_rotate_shift_left and r_bus(4)) or
    (decoder.alu_rotate_shift_right and r_bus(6)) or
    (decoder.alu_swap and r_bus(1))
  ) when clk else '0';

  shifted(6) <= (
    (decoder.alu_rotate_shift_right and r_bus(7)) or
    (decoder.alu_rotate_shift_left and r_bus(5)) or
    (decoder.alu_swap and r_bus(2))
  ) when clk else '0';

  shifted(7) <= (
    (decoder.alu_rr and cf) or
    (decoder.alu_sra and r_bus(7)) or
    (decoder.alu_rrc and r_bus(0)) or
    (decoder.alu_rotate_shift_left and r_bus(6)) or
    (decoder.alu_swap and r_bus(3))
  ) when clk else '0';

  operand_b <= r_bus xor decoder.alu_b_complement;

  hf_inst: entity work.ssdff
  port map (
    clk => decoder.wren_hf_nf_zf,
    en => writeback,
    d => hf_next,
    q => hf
  );

  cf_inst: entity work.ssdff
  port map (
    clk => decoder.wren_cf,
    en => writeback,
    d => cf_next,
    q => cf
  );

  nf_inst: entity work.ssdff
  port map (
    clk => decoder.wren_hf_nf_zf,
    en => writeback,
    d => nf_next,
    q => nf
  );

  z_sign_inst: entity work.ssdff
  port map (
    clk => not phi,
    en => writeback,
    d => z_reg(7),
    q => outputs.z_reg_sign
  );

  zf_inst: entity work.ssdff
  port map (
    clk => decoder.wren_hf_nf_zf,
    en => writeback,
    d => zf_next,
    q => zf
  );

  outputs.data_nand <= operand_a nand operand_b;
  data_and <= operand_a and operand_b;
  data_or <= operand_a or operand_b;
  outputs.data_generate <= data_and;
  outputs.data_propagate <= data_or;
  outputs.data_logic <= shifted or (decoder.alu_logic_and and data_and) or (decoder.alu_logic_or and data_or);
  outputs.flags.half_carry <= hf;
  outputs.flags.carry <= cf;
  outputs.flags.add_subtract <= nf;
  outputs.flags.zero <= zf;
end architecture;
