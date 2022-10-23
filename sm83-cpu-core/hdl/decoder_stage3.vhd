-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83_decoder.all;

-- Instruction decoder stage 3
entity decoder_stage3 is
  port (
    clk: in std_ulogic;
    phi: in std_ulogic;
    writeback: in std_ulogic;
    cb_mode: in std_ulogic;
    ir_reg: in std_ulogic_vector(7 downto 0);
    data_lsb: in std_ulogic;
    stage1: in decoder_stage1_type;
    stage2: in decoder_stage2_type;
    outputs: out decoder_stage3_type
  );
end entity;

-- Real hardware uses dynamic logic (precharge + NMOS transistors + static
-- output inverters), but for simplicity this model uses a simple
-- clock conditions instead
architecture asic of decoder_stage3 is
  signal alu_set_or: std_ulogic;
  signal alu_sum_pos_hf_cf: std_ulogic;
  signal alu_sum_neg_cf: std_ulogic;
  signal alu_sum_neg_hf_nf: std_ulogic;
  signal regpair_wren: std_ulogic;
  signal alu_to_reg: std_ulogic;
  signal cb_20_to_3f: std_ulogic;
  signal rotate: std_ulogic;
  signal alu_daa: std_ulogic;
  signal alu_add_adc: std_ulogic;
  signal alu_sub_sbc: std_ulogic;
  signal alu_cpl: std_ulogic;
  signal alu_cp: std_ulogic;
  signal wren_cf: std_ulogic;
  signal wren_hf_nf_zf: std_ulogic;
  signal op_add_sp_e_sx10: std_ulogic;
  signal op_add_sp_e_s001: std_ulogic;
  signal op_alu_misc_a: std_ulogic;
  signal alu_reg_to_rbus: std_ulogic;
  signal cb_wren_r: std_ulogic;
  signal oe_idu_to_spreg: std_ulogic;
  signal oe_wzreg_to_spreg: std_ulogic;
  signal op_ld_hl_sp_e_s010: std_ulogic;
  signal op_ld_hl_sp_e_s001: std_ulogic;
  signal oe_idu_to_pcreg: std_ulogic;
begin
  outputs.alu_rotate_shift_left <= (
    ((cb_20_to_3f and ir_reg(4) ?= '0') or rotate) and
    ir_reg(3) ?= '0'
  ) when clk ?= '1' else '0';

  outputs.alu_rotate_shift_right <= (
    (cb_20_to_3f or rotate) and ir_reg(3) ?= '1'
  ) when clk ?= '1' else '0';

  alu_set_or <= (
    stage2.alu_set or
    (stage2.op_alu8 and ir_reg(5 downto 3) ?= "110")
  ) when clk ?= '1' else '0';
  outputs.alu_set_or <= alu_set_or;

  outputs.alu_sum <= (
    stage2.op_sp_e_s001 or
    alu_daa or
    stage2.op_sp_e_sx10 or
    stage2.op_jr_any_sx01 or
    alu_sum_neg_cf or
    stage2.op_incdec8 or
    alu_sum_pos_hf_cf
  ) when clk ?= '1' else '0';

  outputs.alu_logic_or <= (
    stage2.op_ld_a_abs_data_cycle or
    stage1.op_ldh_a_x or
    stage1.op_40_to_7f or
    alu_set_or or
    stage1.op_ld_x_n or
    alu_cpl
  ) when clk ?= '1' else '0';

  outputs.alu_rlc <= (
    rotate and ir_reg(4 downto 3) ?= "00"
  ) when clk ?= '1' else '0';

  outputs.alu_rl <= (
    rotate and ir_reg(4 downto 3) ?= "10"
  ) when clk ?= '1' else '0';

  outputs.alu_rrc <= (
    rotate and ir_reg(4 downto 3) ?= "01"
  ) when clk ?= '1' else '0';

  outputs.alu_rr <= (
    rotate and ir_reg(4 downto 3) ?= "11"
  ) when clk ?= '1' else '0';

  outputs.alu_sra <= (
    cb_20_to_3f and ir_reg(4 downto 3) ?= "01"
  ) when clk ?= '1' else '0';

  alu_sum_pos_hf_cf <= (
    stage2.op_sp_e_s001 or
    stage2.op_add_hl_sxx0 or
    stage2.op_add_hl_sx01 or
    alu_add_adc
  ) when clk ?= '1' else '0';
  outputs.alu_sum_pos_hf_cf <= alu_sum_pos_hf_cf;

  alu_sum_neg_cf <= (
    alu_sub_sbc or
    alu_cp
  ) when clk ?= '1' else '0';
  outputs.alu_sum_neg_cf <= alu_sum_neg_cf;

  alu_sum_neg_hf_nf <= (
    alu_sub_sbc or
    alu_cp or
    (stage2.op_incdec8 and ir_reg(0) ?= '1')
  ) when clk ?= '1' else '0';
  outputs.alu_sum_neg_hf_nf <= alu_sum_neg_hf_nf;

  regpair_wren <= (
    stage2.op_incdec_rr or
    stage1.op_ld_rr_sx10 or
    stage1.op_pop_sx10
  ) when clk ?= '1' else '0';
  outputs.regpair_wren <= regpair_wren;

  alu_to_reg <= (
    stage1.op_40_to_7f or
    stage1.op_ld_x_n or
    stage2.op_incdec8
  ) when clk ?= '1' else '0';
  outputs.alu_to_reg <= alu_to_reg;

  outputs.oe_rbus_to_pbus <= (
    stage2.wr and
    (
      stage1.op_40_to_7f or
      stage2.op_ld_abs_a_data_cycle or
      stage1.op_ld_x_n or
      stage1.op_push_sx01 or
      stage2.op_ldh_any_a_data_cycle or
      stage2.op_push_sx10
    )
  ) when phi ?= '0' else '0';

  outputs.alu_swap <= (
    cb_20_to_3f and ir_reg(4 downto 3) ?= "10"
  ) when clk ?= '1' else '0';

  cb_20_to_3f <= (
    stage1.cb_00_to_3f and ir_reg(5) ?= '1'
  ) when clk ?= '1' else '0';
  outputs.cb_20_to_3f <= cb_20_to_3f;

  outputs.alu_xor <= (
    stage2.op_alu8 and ir_reg(5 downto 3) ?= "101"
  ) when clk ?= '1' else '0';

  outputs.alu_logic_and <= (
    stage2.alu_res or
    (stage2.op_alu8 and ir_reg(5 downto 3) ?= "100")
  ) when clk ?= '1' else '0';

  rotate <= (
    stage1.op_rotate_a or
    (stage1.cb_00_to_3f and ir_reg(5) ?= '0')
  ) when clk ?= '1' else '0';
  outputs.rotate <= rotate;

  outputs.alu_ccf_scf <= (
    stage1.op_alu_misc_s0xx and ir_reg(5 downto 4) ?= "11"
  ) when clk ?= '1' else '0';

  alu_daa <= (
    stage1.op_alu_misc_s0xx and ir_reg(5 downto 3) ?= "100"
  ) when clk ?= '1' else '0';
  outputs.alu_daa <= alu_daa;

  alu_add_adc <= (
    stage2.op_alu8 and ir_reg(5 downto 4) ?= "00"
  ) when clk ?= '1' else '0';
  outputs.alu_add_adc <= alu_add_adc;

  alu_sub_sbc <= (
    stage2.op_alu8 and ir_reg(5 downto 4) ?= "01"
  ) when clk ?= '1' else '0';
  outputs.alu_sub_sbc <= alu_sub_sbc;

  outputs.alu_b_complement <= (
    stage2.cb_bit or
    alu_sub_sbc or
    alu_cpl or
    alu_cp
  ) when clk ?= '1' else '0';

  alu_cpl <= (
    stage1.op_alu_misc_s0xx and ir_reg(5 downto 3) ?= "101"
  ) when clk ?= '1' else '0';
  outputs.alu_cpl <= alu_cpl;

  alu_cp <= (
    stage2.op_alu8 and ir_reg(5 downto 3) ?= "111"
  ) when clk ?= '1' else '0';
  outputs.alu_cp <= alu_cp;

  wren_cf <= (
    stage2.allow_r8_write and
    (
      stage1.op_alu_misc_s0xx or
      stage1.cb_00_to_3f or
      stage2.op_alu8 or
      (stage1.op_pop_sx10 and ir_reg(5 downto 4) ?= "11") or
      alu_sum_pos_hf_cf
    )
  ) when phi ?= '0' else '0';
  outputs.wren_cf <= wren_cf;

  wren_hf_nf_zf <= (
    stage2.allow_r8_write and
    (
      stage2.cb_bit or
      wren_cf or
      stage2.op_incdec8
    )
  ) when phi ?= '0' else '0';
  outputs.wren_hf_nf_zf <= wren_hf_nf_zf;

  op_add_sp_e_sx10 <= (
    stage2.op_sp_e_sx10 and ir_reg(4) ?= '0'
  ) when clk ?= '1' else '0';
  outputs.op_add_sp_e_sx10 <= op_add_sp_e_sx10;

  op_add_sp_e_s001 <= (
    stage2.op_sp_e_s001 and ir_reg(4) ?= '0'
  ) when clk ?= '1' else '0';
  outputs.op_add_sp_e_s001 <= op_add_sp_e_s001;

  op_alu_misc_a <= (
    stage1.op_alu_misc_s0xx and (ir_reg(5) ?= '0' or ir_reg(4) ?= '0')
  ) when clk ?= '1' else '0';
  outputs.op_alu_misc_a <= op_alu_misc_a;

  outputs.op_dec8 <= (
    ir_reg(0) and stage2.op_incdec8
  ) when clk ?= '1' else '0';

  alu_reg_to_rbus <= (
    cb_mode or
    stage1.op_40_to_7f or
    stage2.op_alu8
  ) when clk ?= '1' else '0';
  outputs.alu_reg_to_rbus <= alu_reg_to_rbus;

  outputs.oe_areg_to_rbus <= (
    (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "111") or
    stage2.op_ldh_any_a_data_cycle or
    stage2.op_ld_abs_a_data_cycle or
    (
      (
        stage1.op_push_sx01 or
        (stage2.op_incdec8 and ir_reg(3) ?= '1')
      ) and
      ir_reg(5 downto 4) ?= "11"
    ) or
    op_alu_misc_a
  ) when clk ?= '1' else '0';

  cb_wren_r <= (
    stage1.cb_00_to_3f or
    stage2.alu_res or
    stage2.alu_set
  ) when clk ?= '1' else '0';
  outputs.cb_wren_r <= cb_wren_r;

  outputs.oe_alu_to_pbus <= (
    op_add_sp_e_sx10 or
    op_add_sp_e_s001 or
    (
      stage2.wr and
      (
        stage1.cb_00_to_3f or
        stage2.alu_res or
        stage2.op_incdec8 or
        stage2.alu_set
      )
    ) or
    stage2.op_jr_any_sx01
  ) when phi ?= '0' else '0';

  outputs.wren_a <= (
    (
      (stage2.op_alu8 and (ir_reg(5) ?= '0' or ir_reg(4) ?= '0' or ir_reg(3) ?= '0')) or
      (op_alu_misc_a) or
      (cb_wren_r and ir_reg(2 downto 0) ?= "111") or
      (stage2.op_ld_a_abs_data_cycle) or
      (stage1.op_ldh_a_x) or
      (alu_to_reg and ir_reg(5 downto 3) ?= "111") or
      (stage1.op_pop_sx10 and ir_reg(5 downto 4) ?= "11")
    ) and stage2.allow_r8_write
  ) when phi ?= '0' else '0';

  outputs.wren_h <= (
    (
      (cb_wren_r and ir_reg(2 downto 0) ?= "100") or
      op_ld_hl_sp_e_s010 or
      stage2.op_add_hl_sx01 or
      (alu_to_reg and ir_reg(5 downto 3) ?= "100") or
      (regpair_wren and ir_reg(5 downto 4) ?= "10") or
      (stage2.op_ld_abs_rr_sx00 and ir_reg(5) ?= '1')
    ) and stage2.allow_r8_write
  ) when phi ?= '0' else '0';

  outputs.wren_l <= (
    (
      (cb_wren_r and ir_reg(2 downto 0) ?= "101") or
      op_ld_hl_sp_e_s001 or
      stage2.op_add_hl_sxx0 or
      (alu_to_reg and ir_reg(5 downto 3) ?= "101") or
      (regpair_wren and ir_reg(5 downto 4) ?= "10") or
      (stage2.op_ld_abs_rr_sx00 and ir_reg(5) ?= '1')
    ) and stage2.allow_r8_write
  ) when phi ?= '0' else '0';

  outputs.op_reti_s011 <= (
    stage1.op_ret_any_reti_s011 and ir_reg(4) ?= '1' and ir_reg(0) ?= '1'
  ) when clk ?= '1' else '0';

  outputs.oe_hlreg_to_idu <= (
    stage2.addr_hl or
    (stage2.op_incdec_rr and ir_reg(5 downto 4) ?= "10") or
    (stage2.op_ld_abs_rr_sx00 and ir_reg(5) ?= '1')
  ) when clk ?= '1' else '0';

  outputs.oe_hreg_to_rbus <= (
    (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "100") or
    (
      (
        stage1.op_push_sx01 or
        stage2.op_add_hl_sx01 or
        (stage2.op_incdec8 and ir_reg(3) ?= '0')
      ) and ir_reg(5 downto 4) ?= "10"
    )
  ) when clk ?= '1' else '0';

  outputs.oe_lreg_to_rbus <= (
    (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "101") or
    (
      (
        stage2.op_push_sx10 or
        stage2.op_add_hl_sxx0 or
        (stage2.op_incdec8 and ir_reg(3) ?= '1')
      ) and ir_reg(5 downto 4) ?= "10"
    )
  ) when clk ?= '1' else '0';

  outputs.oe_dereg_to_idu <= (
    (
      (
        stage2.op_incdec_rr or
        stage2.op_ld_abs_rr_sx00
      )
      and ir_reg(5 downto 4) ?= "01"
    )
  ) when clk ?= '1' else '0';

  outputs.oe_dreg_to_rbus <= (
    (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "010") or
    (
      (
        stage1.op_push_sx01 or
        stage2.op_add_hl_sx01 or
        (stage2.op_incdec8 and ir_reg(3) ?= '0')
      ) and ir_reg(5 downto 4) ?= "01"
    )
  ) when clk ?= '1' else '0';

  outputs.oe_ereg_to_rbus <= (
    (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "011") or
    (
      (
        stage2.op_push_sx10 or
        stage2.op_add_hl_sxx0 or
        (stage2.op_incdec8 and ir_reg(3) ?= '1')
      ) and ir_reg(5 downto 4) ?= "01"
    )
  ) when clk ?= '1' else '0';

  outputs.wren_d <= (
    (
      (cb_wren_r and ir_reg(2 downto 0) ?= "010") or
      (alu_to_reg and ir_reg(5 downto 3) ?= "010") or
      (regpair_wren and ir_reg(5 downto 4) ?= "01")
    ) and stage2.allow_r8_write
  ) when phi ?= '0' else '0';

  outputs.wren_b <= (
    (
      (cb_wren_r and ir_reg(2 downto 0) ?= "000") or
      (alu_to_reg and ir_reg(5 downto 3) ?= "000") or
      (regpair_wren and ir_reg(5 downto 4) ?= "00")
    ) and stage2.allow_r8_write
  ) when phi ?= '0' else '0';

  outputs.wren_e <= (
    (
      (cb_wren_r and ir_reg(2 downto 0) ?= "011") or
      (alu_to_reg and ir_reg(5 downto 3) ?= "011") or
      (regpair_wren and ir_reg(5 downto 4) ?= "01")
    ) and stage2.allow_r8_write
  ) when phi ?= '0' else '0';

  outputs.wren_c <= (
    (
      (cb_wren_r and ir_reg(2 downto 0) ?= "001") or
      (alu_to_reg and ir_reg(5 downto 3) ?= "001") or
      (regpair_wren and ir_reg(5 downto 4) ?= "00")
    ) and stage2.allow_r8_write
  ) when phi ?= '0' else '0';

  outputs.oe_bcreg_to_idu <= (
    (
      (
        stage2.op_incdec_rr or
        stage2.op_ld_abs_rr_sx00
      )
      and ir_reg(5 downto 4) ?= "00"
    ) or
    stage2.op_ldh_c_sx00
  ) when clk ?= '1' else '0';

  outputs.oe_breg_to_rbus <= (
    (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "000") or
    (
      (
        stage1.op_push_sx01 or
        stage2.op_add_hl_sx01 or
        (stage2.op_incdec8 and ir_reg(3) ?= '0')
      ) and
      ir_reg(5 downto 4) ?= "00"
    )
  ) when clk ?= '1' else '0';

  outputs.oe_creg_to_rbus <= (
    (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "001") or
    (
      (
        stage2.op_push_sx10 or
        stage2.op_add_hl_sxx0 or
        (stage2.op_incdec8 and ir_reg(3) ?= '1')
      ) and
      ir_reg(5 downto 4) ?= "00"
    )
  ) when clk ?= '1' else '0';

  outputs.oe_idu_to_uhlbus <= (
    stage2.op_incdec_rr or
    stage2.op_ld_abs_rr_sx00
  ) when clk ?= '1' and writeback ?= '1' else '0';

  outputs.oe_wzreg_to_uhlbus <= (
    stage1.op_ld_rr_sx10 or
    stage1.op_pop_sx10
  ) when phi ?= '0' else '0';

  outputs.oe_ubus_to_uhlbus <= (
    stage1.cb_00_to_3f or
    op_ld_hl_sp_e_s010 or
    op_ld_hl_sp_e_s001 or
    stage2.op_ld_a_abs_data_cycle or
    stage1.op_ldh_a_x or
    stage2.op_add_hl_sxx0 or
    stage2.op_add_hl_sx01 or
    alu_to_reg or
    stage2.alu_res or
    stage2.alu_set or
    op_alu_misc_a or
    stage1.op_alu8
  ) when clk ?= '1' else '0';

  outputs.oe_zreg_to_rbus <= (
    (
      (alu_reg_to_rbus and ir_reg(2 downto 0) ?= "110") or
      stage1.op_ld_x_n or
      stage2.op_ld_a_abs_data_cycle or
      stage1.op_ldh_a_x or
      stage2.op_sp_e_s001
    ) or
    (stage2.op_incdec8 and ir_reg(5 downto 3) ?= "110") or
    stage2.op_jr_any_sx01
  ) when clk ?= '1' else '0';

  outputs.wren_w <= (
    op_add_sp_e_sx10 or
    stage1.op_ld_nn_sp_s010 or
    (stage2.data_fetch_cycle and not data_lsb) or
    stage2.op_jr_any_sx01
  ) when clk ?= '1' else '0';

  outputs.wren_z <= (
    op_add_sp_e_s001 or
    stage1.op_ld_nn_sp_s010 or
    (stage2.data_fetch_cycle and data_lsb) or
    stage2.op_ldh_imm_sx01 or
    stage2.op_jr_any_sx01
  ) when clk ?= '1' else '0';

  outputs.wren_sp <= (
    oe_idu_to_spreg or
    oe_wzreg_to_spreg
  ) when clk ?= '1' else '0';

  oe_idu_to_spreg <= (
    stage2.stackop or
    stage1.op_ld_sp_hl_sx00 or
    (stage2.op_incdec_rr and ir_reg(5 downto 4) ?= "11")
  ) when clk ?= '1' else '0';
  outputs.oe_idu_to_spreg <= oe_idu_to_spreg;

  oe_wzreg_to_spreg <= (
    stage1.op_add_sp_e_s011 or
    (stage1.op_ld_rr_sx10 and ir_reg(5 downto 4) ?= "11")
  ) when clk ?= '1' else '0';
  outputs.oe_wzreg_to_spreg <= oe_wzreg_to_spreg;

  op_ld_hl_sp_e_s010 <= (
    stage2.op_sp_e_sx10 and ir_reg(4) ?= '1'
  ) when clk ?= '1' else '0';
  outputs.op_ld_hl_sp_e_s010 <= op_ld_hl_sp_e_s010;

  outputs.oe_spreg_to_idu <= (
    (stage2.op_incdec_rr and ir_reg(5 downto 4) ?= "11") or
    stage2.stackop
  ) when clk ?= '1' else '0';

  op_ld_hl_sp_e_s001 <= (
    stage2.op_sp_e_s001 and ir_reg(4) ?= '1'
  ) when clk ?= '1' else '0';
  outputs.op_ld_hl_sp_e_s001 <= op_ld_hl_sp_e_s001;

  oe_idu_to_pcreg <= (
    stage1.op_jp_hl_s0xx or
    stage2.addr_pc or
    stage2.op_jr_any_sx10
  ) when clk ?= '1' else '0';
  outputs.oe_idu_to_pcreg <= oe_idu_to_pcreg;

  outputs.wren_pc <= (
    stage1.int_s110 or
    stage1.op_rst_sx10 or
    stage2.oe_wzreg_to_pcreg or
    oe_idu_to_pcreg
  ) when clk ?= '1' else '0';
end architecture;
