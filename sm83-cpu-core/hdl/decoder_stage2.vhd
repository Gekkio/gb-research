-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83_decoder.all;

-- Instruction decoder stage 2
entity decoder_stage2 is
  port (
    clk: in std_ulogic;
    stage1: in decoder_stage1_type;
    outputs: out decoder_stage2_type
  );
end entity;

-- Real hardware uses dynamic logic (precharge + NMOS transistors + static
-- output inverters), but for simplicity this model uses a simple
-- clock conditions instead
architecture asic of decoder_stage2 is
  signal op_ld_nn_sp_s01x: std_ulogic;
begin
  outputs.cc_check <= (
    stage1.op_jp_cc_sx01 or
    stage1.op_call_cc_sx01 or
    stage1.op_ret_cc_sx00 or
    stage1.op_jr_cc_sx00
  ) when clk ?= '1' else '0';

  outputs.oe_wzreg_to_idu <= (
    stage1.op_ld_nn_a_s010 or
    stage1.op_ld_a_nn_s010 or
    op_ld_nn_sp_s01x
  ) when clk ?= '1' else '0';

  outputs.op_jr_any_sx10 <= stage1.op_jr_any_sx10;
  outputs.op_alu8 <= stage1.op_alu8;

  outputs.op_ld_abs_a_data_cycle <= (
    stage1.op_ld_nn_a_s010 or
    stage1.op_ld_rr_a_sx00
  ) when clk ?= '1' else '0';

  outputs.op_ld_a_abs_data_cycle <= (
    stage1.op_ld_a_nn_s011 or
    stage1.op_ld_a_rr_sx01
  ) when clk ?= '1' else '0';

  outputs.wr <= (
    stage1.op_ld_nn_a_s010 or
    stage1.op_call_any_s011 or
    stage1.op_call_any_s100 or
    stage1.cb_res_hl_sx01 or
    stage1.op_ld_rr_a_sx00 or
    stage1.op_ldh_c_a_sx00 or
    stage1.op_ldh_n_a_sx01 or
    stage1.op_push_sx01 or
    stage1.op_ld_hl_n_sx01 or
    stage1.op_push_sx10 or
    stage1.cb_set_hl_sx01 or
    stage1.op_ld_nn_sp_s010 or
    stage1.op_ld_nn_sp_s011 or
    stage1.op_ld_hl_r_sx00 or
    stage1.op_incdec8_hl_sx01 or
    stage1.op_rst_sx01 or
    stage1.int_s101 or
    stage1.op_rst_sx10 or
    stage1.int_s110 or
    stage1.cb_notbit_hl_sx01
  ) when clk ?= '1' else '0';

  outputs.op_jr_any_sx01 <= stage1.op_jr_any_sx01;

  outputs.op_sp_e_sx10 <= (
    stage1.op_add_sp_e_s010 or
    stage1.op_ld_hl_sp_sx10
  ) when clk ?= '1' else '0';

  outputs.alu_res <= (
    stage1.cb_res_r_sx00 or
    stage1.cb_res_hl_sx01
  ) when clk ?= '1' else '0';

  outputs.addr_valid <= (
    stage1.op_ld_nn_a_s010 or
    stage1.op_ld_a_nn_s010 or
    stage1.op_ld_a_nn_s011 or
    stage1.op_call_any_s000 or
    stage1.op_call_any_s001 or
    stage1.op_call_any_s011 or
    stage1.op_call_any_s100 or
    stage1.op_ld_x_n_sx00 or
    stage1.op_ld_r_n_sx01 or
    stage1.op_s110 or
    stage1.op_s111 or
    stage1.op_jr_any_sx00 or
    stage1.op_ld_hl_sp_sx10 or
    stage1.cb_res_r_sx00 or
    stage1.cb_res_hl_sx01 or
    stage1.op_ld_a_rr_sx01 or
    stage1.op_ld_rr_a_sx00 or
    stage1.op_ld_a_rr_sx00 or
    stage1.op_ldh_c_a_sx00 or
    stage1.op_ldh_n_a_sx00 or
    stage1.op_ld_r_hl_sx00 or
    stage1.op_alu_misc_s0xx or
    stage1.op_push_sx01 or
    stage1.op_ld_r_r_s0xx or
    stage1.op_jp_any_sx00 or
    stage1.op_jp_any_sx01 or
    stage1.op_add_hl_sx01 or
    stage1.op_ld_hl_n_sx01 or
    stage1.op_push_sx10 or
    stage1.op_pop_sx00 or
    stage1.op_pop_sx01 or
    stage1.cb_set_r_sx00 or
    stage1.cb_set_hl_sx01 or
    stage1.cb_set_res_hl_sx00 or
    stage1.op_pop_sx10 or
    stage1.op_ld_nn_sp_s010 or
    stage1.op_ld_nn_sp_s000 or
    stage1.op_add_sp_e_s000 or
    stage1.op_add_sp_e_s011 or
    stage1.op_ld_hl_sp_sx00 or
    stage1.op_ld_nn_sp_s011 or
    stage1.op_ld_nn_sp_s001 or
    stage1.op_ld_hl_r_sx00 or
    stage1.op_incdec8_hl_sx00 or
    stage1.op_incdec8_hl_sx01 or
    stage1.op_ldh_a_c_sx00 or
    stage1.op_ldh_a_n_sx00 or
    stage1.op_rst_sx01 or
    stage1.int_s101 or
    stage1.op_80_to_bf_reg_s0xx or
    stage1.op_ret_reti_sx00 or
    stage1.op_ret_cc_sx01 or
    stage1.op_jp_hl_s0xx or
    stage1.op_ret_any_reti_s010 or
    stage1.op_ld_rr_sx00 or
    stage1.op_ld_rr_sx01 or
    stage1.op_ld_rr_sx10 or
    stage1.op_incdec8_s0xx or
    stage1.op_alu_hl_sx00 or
    stage1.op_alu_n_sx00 or
    stage1.op_rst_sx10 or
    stage1.int_s110 or
    stage1.cb_r_s0xx or
    stage1.cb_hl_sx00 or
    stage1.cb_bit_hl_sx01 or
    stage1.cb_notbit_hl_sx01 or
    stage1.op_di_ei_s0xx or
    stage1.op_halt_s0xx or
    stage1.op_nop_stop_s0xx or
    stage1.op_cb_s0xx or
    stage1.op_jr_any_sx10 or
    stage1.op_ea_fa_s000 or
    stage1.op_ea_fa_s001 or
    stage1.op_ldh_a_n_sx01 or
    stage1.op_ldh_n_a_sx01
  ) when clk ?= '1' else '0';

  outputs.cb_bit <= stage1.cb_bit;

  outputs.op_ld_abs_rr_sx00 <= (
    stage1.op_ld_rr_a_sx00 or
    stage1.op_ld_a_rr_sx00
  ) when clk ?= '1' else '0';

  outputs.op_ldh_any_a_data_cycle <= (
    stage1.op_ldh_c_a_sx00 or
    stage1.op_ldh_n_a_sx01
  ) when clk ?= '1' else '0';

  outputs.op_add_hl_sxx0 <= stage1.op_add_hl_sxx0;

  outputs.op_incdec_rr <= (
    stage1.op_dec_rr_sx00 or
    stage1.op_inc_rr_sx00
  ) when clk ?= '1' else '0';

  outputs.op_ldh_imm_sx01 <= (
    stage1.op_ldh_n_a_sx01 or
    stage1.op_ldh_a_n_sx01
  ) when clk ?= '1' else '0';

  outputs.state0_next <= (
    stage1.op_ld_nn_a_s010 or
    stage1.op_ld_a_nn_s010 or
    stage1.op_ret_cc_sx00 or
    stage1.op_call_any_s000 or
    stage1.op_call_any_s010 or
    stage1.op_call_any_s100 or
    stage1.op_ld_x_n_sx00 or
    stage1.op_jr_any_sx00 or
    stage1.op_add_sp_e_s010 or
    stage1.cb_res_hl_sx01 or
    stage1.op_ld_rr_a_sx00 or
    stage1.op_ld_a_rr_sx00 or
    stage1.op_ldh_c_a_sx00 or
    stage1.op_ldh_n_a_sx00 or
    stage1.op_ldh_n_a_sx01 or
    stage1.op_add_hl_sxx0 or
    stage1.op_dec_rr_sx00 or
    stage1.op_inc_rr_sx00 or
    stage1.op_push_sx00 or
    stage1.op_jp_any_sx00 or
    stage1.op_jp_any_sx10 or
    stage1.op_ld_hl_n_sx01 or
    stage1.op_push_sx10 or
    stage1.op_pop_sx00 or
    stage1.cb_set_hl_sx01 or
    stage1.cb_set_res_hl_sx00 or
    stage1.op_ld_nn_sp_s010 or
    stage1.op_ld_nn_sp_s000 or
    stage1.op_ld_sp_hl_sx00 or
    stage1.op_add_sp_e_s000 or
    stage1.op_ld_hl_sp_sx00 or
    stage1.op_ld_nn_sp_s011 or
    stage1.op_ld_hl_r_sx00 or
    stage1.op_incdec8_hl_sx00 or
    stage1.op_incdec8_hl_sx01 or
    stage1.op_ldh_a_n_sx00 or
    stage1.op_rst_sx00 or
    stage1.int_s100 or
    stage1.op_ret_any_reti_s010 or
    stage1.op_ret_any_reti_s011 or
    stage1.op_ld_rr_sx00 or
    stage1.op_rst_sx10 or
    stage1.int_s110 or
    stage1.cb_hl_sx00 or
    stage1.cb_notbit_hl_sx01 or
    stage1.op_ea_fa_s000
  ) when clk ?= '1' else '0';

  outputs.data_fetch_cycle <= (
    stage1.op_ld_a_nn_s010 or
    stage1.op_call_any_s000 or
    stage1.op_call_any_s001 or
    stage1.op_ld_x_n_sx00 or
    stage1.op_jr_any_sx00 or
    stage1.op_ld_a_rr_sx00 or
    stage1.op_ldh_n_a_sx00 or
    stage1.op_ld_r_hl_sx00 or
    stage1.op_jp_any_sx00 or
    stage1.op_jp_any_sx01 or
    stage1.op_pop_sx00 or
    stage1.op_pop_sx01 or
    stage1.op_ldh_a_n_sx01 or
    stage1.op_ld_nn_sp_s000 or
    stage1.op_add_sp_e_s000 or
    stage1.op_ld_hl_sp_sx00 or
    stage1.op_ld_nn_sp_s001 or
    stage1.op_incdec8_hl_sx00 or
    stage1.op_ldh_a_c_sx00 or
    stage1.op_ldh_a_n_sx00 or
    stage1.op_ret_reti_sx00 or
    stage1.op_ret_cc_sx01 or
    stage1.op_ret_any_reti_s010 or
    stage1.op_ld_rr_sx00 or
    stage1.op_ld_rr_sx01 or
    stage1.op_alu_hl_sx00 or
    stage1.op_alu_n_sx00 or
    stage1.cb_hl_sx00 or
    stage1.op_ea_fa_s000 or
    stage1.op_ea_fa_s001
  ) when clk ?= '1' else '0';

  outputs.op_add_hl_sx01 <= stage1.op_add_hl_sx01;
  outputs.op_push_sx10 <= stage1.op_push_sx10;

  outputs.addr_hl <= (
    stage1.cb_res_hl_sx01 or
    stage1.op_ld_r_hl_sx00 or
    stage1.op_ld_hl_n_sx01 or
    stage1.cb_set_hl_sx01 or
    stage1.cb_set_res_hl_sx00 or
    stage1.op_ld_sp_hl_sx00 or
    stage1.op_ld_hl_r_sx00 or
    stage1.op_incdec8_hl_sx00 or
    stage1.op_incdec8_hl_sx01 or
    stage1.op_jp_hl_s0xx or
    stage1.op_alu_hl_sx00 or
    stage1.cb_hl_sx00 or
    stage1.cb_notbit_hl_sx01
  ) when clk ?= '1' else '0';

  outputs.op_sp_e_s001 <= (
    stage1.op_add_sp_s001 or
    stage1.op_ld_hl_sp_sx01
  ) when clk ?= '1' else '0';

  outputs.alu_set <= (
    stage1.cb_set_r_sx00 or
    stage1.cb_set_hl_sx01
  ) when clk ?= '1' else '0';

  outputs.addr_pc <= (
    stage1.op_ld_a_nn_s011 or
    stage1.op_call_any_s000 or
    stage1.op_call_any_s001 or
    stage1.op_ld_x_n_sx00 or
    stage1.op_ld_r_n_sx01 or
    stage1.op_s110 or
    stage1.op_s111 or
    stage1.op_jr_any_sx00 or
    stage1.op_ld_hl_sp_sx10 or
    stage1.cb_res_r_sx00 or
    stage1.op_ld_a_rr_sx01 or
    stage1.op_ldh_n_a_sx00 or
    stage1.op_alu_misc_s0xx or
    stage1.op_ld_r_r_s0xx or
    stage1.op_jp_any_sx00 or
    stage1.op_jp_any_sx01 or
    stage1.op_add_hl_sx01 or
    stage1.cb_set_r_sx00 or
    stage1.op_pop_sx10 or
    stage1.op_ld_nn_sp_s000 or
    stage1.op_add_sp_e_s000 or
    stage1.op_add_sp_e_s011 or
    stage1.op_ld_hl_sp_sx00 or
    stage1.op_ld_nn_sp_s001 or
    stage1.op_ldh_a_n_sx00 or
    stage1.int_s000 or
    stage1.op_80_to_bf_reg_s0xx or
    stage1.op_ld_rr_sx00 or
    stage1.op_ld_rr_sx01 or
    stage1.op_ld_rr_sx10 or
    stage1.op_incdec8_s0xx or
    stage1.op_alu_n_sx00 or
    stage1.cb_r_s0xx or
    stage1.cb_bit_hl_sx01 or
    stage1.op_di_ei_s0xx or
    stage1.op_halt_s0xx or
    stage1.op_nop_stop_s0xx or
    stage1.op_cb_s0xx or
    stage1.op_ea_fa_s000 or
    stage1.op_ea_fa_s001
  ) when clk ?= '1' else '0';

  outputs.m1 <= (
    stage1.op_ld_a_nn_s011 or
    stage1.op_ld_r_n_sx01 or
    stage1.op_s110 or
    stage1.op_s111 or
    stage1.op_ld_hl_sp_sx10 or
    stage1.cb_res_r_sx00 or
    stage1.op_ld_a_rr_sx01 or
    stage1.op_alu_misc_s0xx or
    stage1.op_ld_r_r_s0xx or
    stage1.op_add_hl_sx01 or
    stage1.cb_set_r_sx00 or
    stage1.op_pop_sx10 or
    stage1.op_add_sp_e_s011 or
    stage1.op_80_to_bf_reg_s0xx or
    stage1.op_jp_hl_s0xx or
    stage1.op_ld_rr_sx10 or
    stage1.op_incdec8_s0xx or
    stage1.cb_r_s0xx or
    stage1.cb_bit_hl_sx01 or
    stage1.op_di_ei_s0xx or
    stage1.op_halt_s0xx or
    stage1.op_nop_stop_s0xx or
    stage1.op_cb_s0xx or
    stage1.op_jr_any_sx10
  ) when clk ?= '1' else '0';

  op_ld_nn_sp_s01x <= (
    stage1.op_ld_nn_sp_s010 or
    stage1.op_ld_nn_sp_s011
  ) when clk ?= '1' else '0';
  outputs.op_ld_nn_sp_s01x <= op_ld_nn_sp_s01x;

  outputs.oe_pchreg_to_pbus <= (
    stage1.op_call_any_s011 or
    stage1.op_rst_sx01 or
    stage1.int_s101
  ) when clk ?= '1' else '0';

  outputs.op_ldh_c_sx00 <= (
    stage1.op_ldh_c_a_sx00 or
    stage1.op_ldh_a_c_sx00
  ) when clk ?= '1' else '0';

  outputs.stackop <= (
    stage1.op_call_any_s010 or
    stage1.op_call_any_s011 or
    stage1.op_call_any_s100 or
    stage1.op_push_sx01 or
    stage1.op_push_sx00 or
    stage1.op_push_sx10 or
    stage1.op_pop_sx00 or
    stage1.op_pop_sx01 or
    stage1.op_rst_sx01 or
    stage1.op_rst_sx00 or
    stage1.int_s101 or
    stage1.int_s100 or
    stage1.op_ret_reti_sx00 or
    stage1.op_ret_cc_sx01 or
    stage1.op_ret_any_reti_s010 or
    stage1.op_rst_sx10 or
    stage1.int_s110
  ) when clk ?= '1' else '0';

  outputs.idu_inc <= (
    stage1.op_ld_a_nn_s011 or
    stage1.op_call_any_s000 or
    stage1.op_call_any_s001 or
    stage1.op_ld_x_n_sx00 or
    stage1.op_ld_r_n_sx01 or
    stage1.op_s110 or
    stage1.op_s111 or
    stage1.op_jr_any_sx00 or
    stage1.op_ld_hl_sp_sx10 or
    stage1.cb_res_r_sx00 or
    stage1.op_ld_a_rr_sx01 or
    stage1.op_ldh_n_a_sx00 or
    stage1.op_alu_misc_s0xx or
    stage1.op_inc_rr_sx00 or
    stage1.op_ld_r_r_s0xx or
    stage1.op_jp_any_sx00 or
    stage1.op_jp_any_sx01 or
    stage1.op_add_hl_sx01 or
    stage1.op_pop_sx00 or
    stage1.op_pop_sx01 or
    stage1.cb_set_r_sx00 or
    stage1.op_pop_sx10 or
    stage1.op_ld_nn_sp_s010 or
    stage1.op_ld_nn_sp_s000 or
    stage1.op_add_sp_e_s000 or
    stage1.op_add_sp_e_s011 or
    stage1.op_ld_hl_sp_sx00 or
    stage1.op_ld_nn_sp_s001 or
    stage1.op_ldh_a_n_sx00 or
    stage1.op_80_to_bf_reg_s0xx or
    stage1.op_ret_reti_sx00 or
    stage1.op_ret_cc_sx01 or
    stage1.op_jp_hl_s0xx or
    stage1.op_ret_any_reti_s010 or
    stage1.op_ld_hlinc_sx00 or
    stage1.op_ld_rr_sx00 or
    stage1.op_ld_rr_sx01 or
    stage1.op_ld_rr_sx10 or
    stage1.op_incdec8_s0xx or
    stage1.op_alu_n_sx00 or
    stage1.cb_r_s0xx or
    stage1.cb_bit_hl_sx01 or
    stage1.op_di_ei_s0xx or
    stage1.op_nop_stop_s0xx or
    stage1.op_cb_s0xx or
    stage1.op_jr_any_sx10 or
    stage1.op_ea_fa_s000 or
    stage1.op_ea_fa_s001
  ) when clk ?= '1' else '0';

  outputs.state2_next <= (
    stage1.op_ld_nn_a_s010 or
    stage1.op_call_any_s011 or
    stage1.op_call_any_s100 or
    stage1.cb_res_hl_sx01 or
    stage1.op_ld_rr_a_sx00 or
    stage1.op_ldh_c_a_sx00 or
    stage1.op_ldh_n_a_sx01 or
    stage1.op_ld_r_hl_sx00 or
    stage1.op_dec_rr_sx00 or
    stage1.op_inc_rr_sx00 or
    stage1.op_jp_any_sx10 or
    stage1.op_ld_hl_n_sx01 or
    stage1.op_push_sx10 or
    stage1.cb_set_hl_sx01 or
    stage1.op_ldh_a_n_sx01 or
    stage1.op_ld_sp_hl_sx00 or
    stage1.op_ld_nn_sp_s011 or
    stage1.op_ld_hl_r_sx00 or
    stage1.op_incdec8_hl_sx01 or
    stage1.op_ldh_a_c_sx00 or
    stage1.int_s101 or
    stage1.int_s100 or
    stage1.int_s000 or
    stage1.op_ret_any_reti_s011 or
    stage1.op_alu_hl_sx00 or
    stage1.op_alu_n_sx00 or
    stage1.op_rst_sx10 or
    stage1.int_s110 or
    stage1.cb_notbit_hl_sx01
  ) when clk ?= '1' else '0';

  outputs.state1_next <= (
    stage1.op_ld_nn_a_s010 or
    stage1.op_ld_a_nn_s010 or
    stage1.op_call_any_s001 or
    stage1.op_call_any_s010 or
    stage1.op_call_any_s100 or
    stage1.op_jr_any_sx01 or
    stage1.op_add_sp_e_s010 or
    stage1.cb_res_hl_sx01 or
    stage1.op_ld_rr_a_sx00 or
    stage1.op_ldh_c_a_sx00 or
    stage1.op_ldh_n_a_sx01 or
    stage1.op_ld_r_hl_sx00 or
    stage1.op_dec_rr_sx00 or
    stage1.op_inc_rr_sx00 or
    stage1.op_push_sx01 or
    stage1.op_jp_any_sx01 or
    stage1.op_jp_any_sx10 or
    stage1.op_ld_hl_n_sx01 or
    stage1.op_push_sx10 or
    stage1.op_pop_sx01 or
    stage1.op_add_sp_s001 or
    stage1.op_ld_hl_sp_sx01 or
    stage1.cb_set_hl_sx01 or
    stage1.op_ldh_a_n_sx01 or
    stage1.op_ld_nn_sp_s010 or
    stage1.op_ld_sp_hl_sx00 or
    stage1.op_ld_nn_sp_s011 or
    stage1.op_ld_nn_sp_s001 or
    stage1.op_ld_hl_r_sx00 or
    stage1.op_incdec8_hl_sx01 or
    stage1.op_ldh_a_c_sx00 or
    stage1.op_rst_sx01 or
    stage1.int_s101 or
    stage1.op_ret_reti_sx00 or
    stage1.op_ret_cc_sx01 or
    stage1.op_ret_any_reti_s010 or
    stage1.op_ret_any_reti_s011 or
    stage1.op_ld_rr_sx01 or
    stage1.op_alu_hl_sx00 or
    stage1.op_alu_n_sx00 or
    stage1.op_rst_sx10 or
    stage1.int_s110 or
    stage1.cb_notbit_hl_sx01 or
    stage1.op_ea_fa_s001
  ) when clk ?= '1' else '0';

  outputs.oe_pclreg_to_pbus <= (
    stage1.op_call_any_s100 or
    stage1.op_rst_sx10 or
    stage1.int_s110
  ) when clk ?= '1' else '0';

  outputs.idu_dec <= (
    stage1.op_call_any_s010 or
    stage1.op_call_any_s011 or
    stage1.op_dec_rr_sx00 or
    stage1.op_push_sx01 or
    stage1.op_push_sx00 or
    stage1.op_rst_sx01 or
    stage1.op_rst_sx00 or
    stage1.int_s101 or
    stage1.int_s100 or
    stage1.int_s000 or
    stage1.op_ld_hldec_sx00
  ) when clk ?= '1' else '0';

  outputs.oe_wzreg_to_pcreg <= (
    stage1.op_call_any_s100 or
    stage1.op_jp_any_sx10 or
    stage1.op_ret_any_reti_s011
  ) when clk ?= '1' else '0';

  outputs.op_incdec8 <= stage1.op_incdec8;

  outputs.allow_r8_write <= (
    stage1.op_ld_a_nn_s011 or
    stage1.op_call_any_s100 or
    stage1.op_ld_r_n_sx01 or
    stage1.op_s110 or
    stage1.op_ld_hl_sp_sx10 or
    stage1.cb_res_r_sx00 or
    stage1.op_ld_a_rr_sx01 or
    stage1.op_ld_rr_a_sx00 or
    stage1.op_ld_a_rr_sx00 or
    stage1.op_alu_misc_s0xx or
    stage1.op_add_hl_sxx0 or
    stage1.op_dec_rr_sx00 or
    stage1.op_inc_rr_sx00 or
    stage1.op_push_sx01 or
    stage1.op_ld_r_r_s0xx or
    stage1.op_jp_any_sx10 or
    stage1.op_add_hl_sx01 or
    stage1.op_push_sx10 or
    stage1.op_add_sp_s001 or
    stage1.op_ld_hl_sp_sx01 or
    stage1.cb_set_r_sx00 or
    stage1.op_pop_sx10 or
    stage1.op_ld_sp_hl_sx00 or
    stage1.op_ld_hl_r_sx00 or
    stage1.op_incdec8_hl_sx01 or
    stage1.op_80_to_bf_reg_s0xx or
    stage1.op_jp_hl_s0xx or
    stage1.op_ld_rr_sx10 or
    stage1.op_incdec8_s0xx or
    stage1.op_rst_sx10 or
    stage1.int_s110 or
    stage1.cb_r_s0xx or
    stage1.cb_bit_hl_sx01 or
    stage1.cb_notbit_hl_sx01 or
    stage1.op_di_ei_s0xx or
    stage1.op_halt_s0xx or
    stage1.op_nop_stop_s0xx
  ) when clk ?= '1' else '0';
end architecture;
