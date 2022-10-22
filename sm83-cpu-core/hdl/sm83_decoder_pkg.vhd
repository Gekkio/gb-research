-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

package sm83_decoder is
  type decoder_stage1_type is record
    op_ld_nn_a_s010: std_ulogic;
    op_ld_a_nn_s010: std_ulogic;
    op_ld_a_nn_s011: std_ulogic;
    op_alu8: std_ulogic;
    op_jp_cc_sx01: std_ulogic;
    op_call_cc_sx01: std_ulogic;
    op_ret_cc_sx00: std_ulogic;
    op_jr_cc_sx00: std_ulogic;
    op_ldh_a_x: std_ulogic;
    op_call_any_s000: std_ulogic;
    op_call_any_s001: std_ulogic;
    op_call_any_s010: std_ulogic;
    op_call_any_s011: std_ulogic;
    op_call_any_s100: std_ulogic;
    op_ld_x_n: std_ulogic;
    op_ld_x_n_sx00: std_ulogic;
    op_ld_r_n_sx01: std_ulogic;
    op_s110: std_ulogic;
    op_s111: std_ulogic;
    op_jr_any_sx01: std_ulogic;
    op_jr_any_sx00: std_ulogic;
    op_add_sp_e_s010: std_ulogic;
    op_ld_hl_sp_sx10: std_ulogic;
    cb_res_r_sx00: std_ulogic;
    cb_res_hl_sx01: std_ulogic;
    op_rotate_a: std_ulogic;
    op_ld_a_rr_sx01: std_ulogic;
    cb_bit: std_ulogic;
    op_ld_rr_a_sx00: std_ulogic;
    op_ld_a_rr_sx00: std_ulogic;
    op_ldh_c_a_sx00: std_ulogic;
    op_ldh_n_a_sx00: std_ulogic;
    op_ldh_n_a_sx01: std_ulogic;
    op_ld_r_hl_sx00: std_ulogic;
    op_alu_misc_s0xx: std_ulogic;
    op_add_hl_sxx0: std_ulogic;
    op_dec_rr_sx00: std_ulogic;
    op_inc_rr_sx00: std_ulogic;
    op_push_sx01: std_ulogic;
    op_push_sx00: std_ulogic;
    op_ld_r_r_s0xx: std_ulogic;
    op_40_to_7f: std_ulogic;
    cb_00_to_3f: std_ulogic;
    op_jp_any_sx00: std_ulogic;
    op_jp_any_sx01: std_ulogic;
    op_jp_any_sx10: std_ulogic;
    op_add_hl_sx01: std_ulogic;
    op_ld_hl_n_sx01: std_ulogic;
    op_push_sx10: std_ulogic;
    op_pop_sx00: std_ulogic;
    op_pop_sx01: std_ulogic;
    op_add_sp_s001: std_ulogic;
    op_ld_hl_sp_sx01: std_ulogic;
    cb_set_r_sx00: std_ulogic;
    cb_set_hl_sx01: std_ulogic;
    cb_set_res_hl_sx00: std_ulogic;
    op_pop_sx10: std_ulogic;
    op_ldh_a_n_sx01: std_ulogic;
    op_ld_nn_sp_s010: std_ulogic;
    op_ld_nn_sp_s000: std_ulogic;
    op_ld_sp_hl_sx00: std_ulogic;
    op_add_sp_e_s000: std_ulogic;
    op_add_sp_e_s011: std_ulogic;
    op_ld_hl_sp_sx00: std_ulogic;
    op_ld_nn_sp_s011: std_ulogic;
    op_ld_nn_sp_s001: std_ulogic;
    op_ld_hl_r_sx00: std_ulogic;
    op_incdec8_hl_sx00: std_ulogic;
    op_incdec8_hl_sx01: std_ulogic;
    op_ldh_a_c_sx00: std_ulogic;
    op_ldh_a_n_sx00: std_ulogic;
    op_rst_sx01: std_ulogic;
    op_rst_sx00: std_ulogic;
    int_s101: std_ulogic;
    int_s100: std_ulogic;
    int_s000: std_ulogic;
    op_80_to_bf_reg_s0xx: std_ulogic;
    op_ret_reti_sx00: std_ulogic;
    op_ret_cc_sx01: std_ulogic;
    op_jp_hl_s0xx: std_ulogic;
    op_ret_any_reti_s010: std_ulogic;
    op_ret_any_reti_s011: std_ulogic;
    op_ld_hlinc_sx00: std_ulogic;
    op_ld_hldec_sx00: std_ulogic;
    op_ld_rr_sx00: std_ulogic;
    op_ld_rr_sx01: std_ulogic;
    op_ld_rr_sx10: std_ulogic;
    op_incdec8_s0xx: std_ulogic;
    op_alu_hl_sx00: std_ulogic;
    op_alu_n_sx00: std_ulogic;
    op_rst_sx10: std_ulogic;
    int_s110: std_ulogic;
    cb_r_s0xx: std_ulogic;
    cb_hl_sx00: std_ulogic;
    cb_bit_hl_sx01: std_ulogic;
    cb_notbit_hl_sx01: std_ulogic;
    op_incdec8: std_ulogic;
    op_di_ei_s0xx: std_ulogic;
    op_halt_s0xx: std_ulogic;
    op_nop_stop_s0xx: std_ulogic;
    op_cb_s0xx: std_ulogic;
    op_jr_any_sx10: std_ulogic;
    op_ea_fa_s000: std_ulogic;
    op_ea_fa_s001: std_ulogic;
  end record;

  type decoder_stage2_type is record
    cc_check: std_ulogic;
    oe_wzreg_to_idu: std_ulogic;
    op_jr_any_sx10: std_ulogic;
    op_alu8: std_ulogic;
    op_ld_abs_a_data_cycle: std_ulogic;
    op_ld_a_abs_data_cycle: std_ulogic;
    wr: std_ulogic;
    op_jr_any_sx01: std_ulogic;
    op_sp_e_sx10: std_ulogic;
    alu_res: std_ulogic;
    addr_valid: std_ulogic;
    cb_bit: std_ulogic;
    op_ld_abs_rr_sx00: std_ulogic;
    op_ldh_any_a_data_cycle: std_ulogic;
    op_add_hl_sxx0: std_ulogic;
    op_incdec_rr: std_ulogic;
    op_ldh_imm_sx01: std_ulogic;
    state0_next: std_ulogic;
    data_fetch_cycle: std_ulogic;
    op_add_hl_sx01: std_ulogic;
    op_push_sx10: std_ulogic;
    addr_hl: std_ulogic;
    op_sp_e_s001: std_ulogic;
    alu_set: std_ulogic;
    addr_pc: std_ulogic;
    m1: std_ulogic;
    op_ld_nn_sp_s01x: std_ulogic;
    oe_pchreg_to_pbus: std_ulogic;
    op_ldh_c_sx00: std_ulogic;
    stackop: std_ulogic;
    idu_inc: std_ulogic;
    state2_next: std_ulogic;
    state1_next: std_ulogic;
    oe_pclreg_to_pbus: std_ulogic;
    idu_dec: std_ulogic;
    oe_wzreg_to_pcreg: std_ulogic;
    op_incdec8: std_ulogic;
    allow_r8_write: std_ulogic;
  end record;

  type decoder_stage3_type is record
    alu_rotate_shift_left: std_ulogic;
    alu_rotate_shift_right: std_ulogic;
    alu_set_or: std_ulogic;
    alu_sum: std_ulogic;
    alu_logic_or: std_ulogic;
    alu_rlc: std_ulogic;
    alu_rl: std_ulogic;
    alu_rrc: std_ulogic;
    alu_rr: std_ulogic;
    alu_sra: std_ulogic;
    alu_sum_pos_hf_cf: std_ulogic;
    alu_sum_neg_cf: std_ulogic;
    alu_sum_neg_hf_nf: std_ulogic;
    regpair_wren: std_ulogic;
    alu_to_reg: std_ulogic;
    oe_rbus_to_pbus: std_ulogic;
    alu_swap: std_ulogic;
    cb_20_to_3f: std_ulogic;
    alu_xor: std_ulogic;
    alu_logic_and: std_ulogic;
    rotate: std_ulogic;
    alu_ccf_scf: std_ulogic;
    alu_daa: std_ulogic;
    alu_add_adc: std_ulogic;
    alu_sub_sbc: std_ulogic;
    alu_b_complement: std_ulogic;
    alu_cpl: std_ulogic;
    alu_cp: std_ulogic;
    wren_cf: std_ulogic;
    wren_hf_nf_zf: std_ulogic;
    op_add_sp_e_sx10: std_ulogic;
    op_add_sp_e_s001: std_ulogic;
    op_alu_misc_a: std_ulogic;
    op_dec8: std_ulogic;
    alu_reg_to_rbus: std_ulogic;
    oe_areg_to_rbus: std_ulogic;
    cb_wren_r: std_ulogic;
    oe_alu_to_pbus: std_ulogic;
    wren_a: std_ulogic;
    wren_h: std_ulogic;
    wren_l: std_ulogic;
    op_reti_s011: std_ulogic;
    oe_hlreg_to_idu: std_ulogic;
    oe_hreg_to_rbus: std_ulogic;
    oe_lreg_to_rbus: std_ulogic;
    oe_dereg_to_idu: std_ulogic;
    oe_dreg_to_rbus: std_ulogic;
    oe_ereg_to_rbus: std_ulogic;
    wren_d: std_ulogic;
    wren_b: std_ulogic;
    wren_e: std_ulogic;
    wren_c: std_ulogic;
    oe_bcreg_to_idu: std_ulogic;
    oe_breg_to_rbus: std_ulogic;
    oe_creg_to_rbus: std_ulogic;
    oe_idu_to_uhlbus: std_ulogic;
    oe_wzreg_to_uhlbus: std_ulogic;
    oe_ubus_to_uhlbus: std_ulogic;
    oe_zreg_to_rbus: std_ulogic;
    wren_w: std_ulogic;
    wren_z: std_ulogic;
    wren_sp: std_ulogic;
    oe_idu_to_spreg: std_ulogic;
    oe_wzreg_to_spreg: std_ulogic;
    op_ld_hl_sp_e_s010: std_ulogic;
    oe_spreg_to_idu: std_ulogic;
    op_ld_hl_sp_e_s001: std_ulogic;
    oe_idu_to_pcreg: std_ulogic;
    wren_pc: std_ulogic;
  end record;

  type decoder_type is record
    cb_00_to_3f: std_ulogic;
    op_pop_sx10: std_ulogic;
    op_ld_nn_sp_s010: std_ulogic;
    op_ld_nn_sp_s011: std_ulogic;
    op_rst_sx10: std_ulogic;
    int_s110: std_ulogic;
    op_di_ei_s0xx: std_ulogic;
    op_halt_s0xx: std_ulogic;
    op_nop_stop_s0xx: std_ulogic;
    op_cb_s0xx: std_ulogic;
    cc_check: std_ulogic;
    oe_wzreg_to_idu: std_ulogic;
    op_jr_any_sx10: std_ulogic;
    op_alu8: std_ulogic;
    wr: std_ulogic;
    m1: std_ulogic;
    op_jr_any_sx01: std_ulogic;
    op_sp_e_sx10: std_ulogic;
    alu_res: std_ulogic;
    addr_valid: std_ulogic;
    cb_bit: std_ulogic;
    op_add_hl_sxx0: std_ulogic;
    op_incdec_rr: std_ulogic;
    op_ldh_imm_sx01: std_ulogic;
    state0_next: std_ulogic;
    data_fetch_cycle: std_ulogic;
    op_add_hl_sx01: std_ulogic;
    op_push_sx10: std_ulogic;
    op_sp_e_s001: std_ulogic;
    alu_set: std_ulogic;
    addr_pc: std_ulogic;
    oe_pchreg_to_pbus: std_ulogic;
    op_ldh_c_sx00: std_ulogic;
    idu_inc: std_ulogic;
    state2_next: std_ulogic;
    state1_next: std_ulogic;
    oe_pclreg_to_pbus: std_ulogic;
    idu_dec: std_ulogic;
    oe_wzreg_to_pcreg: std_ulogic;
    op_incdec8: std_ulogic;
    alu_rotate_shift_left: std_ulogic;
    alu_rotate_shift_right: std_ulogic;
    alu_sum: std_ulogic;
    alu_logic_or: std_ulogic;
    alu_rlc: std_ulogic;
    alu_rl: std_ulogic;
    alu_rrc: std_ulogic;
    alu_rr: std_ulogic;
    alu_sra: std_ulogic;
    alu_sum_pos_hf_cf: std_ulogic;
    alu_sum_neg_cf: std_ulogic;
    alu_sum_neg_hf_nf: std_ulogic;
    oe_rbus_to_pbus: std_ulogic;
    alu_swap: std_ulogic;
    alu_xor: std_ulogic;
    alu_logic_and: std_ulogic;
    alu_ccf_scf: std_ulogic;
    alu_daa: std_ulogic;
    alu_add_adc: std_ulogic;
    alu_sub_sbc: std_ulogic;
    alu_b_complement: std_ulogic;
    alu_cpl: std_ulogic;
    alu_cp: std_ulogic;
    wren_cf: std_ulogic;
    wren_hf_nf_zf: std_ulogic;
    op_dec8: std_ulogic;
    oe_areg_to_rbus: std_ulogic;
    oe_alu_to_pbus: std_ulogic;
    wren_a: std_ulogic;
    wren_h: std_ulogic;
    wren_l: std_ulogic;
    op_reti_s011: std_ulogic;
    oe_hlreg_to_idu: std_ulogic;
    oe_hreg_to_rbus: std_ulogic;
    oe_lreg_to_rbus: std_ulogic;
    oe_dereg_to_idu: std_ulogic;
    oe_dreg_to_rbus: std_ulogic;
    oe_ereg_to_rbus: std_ulogic;
    wren_d: std_ulogic;
    wren_b: std_ulogic;
    wren_e: std_ulogic;
    wren_c: std_ulogic;
    oe_bcreg_to_idu: std_ulogic;
    oe_breg_to_rbus: std_ulogic;
    oe_creg_to_rbus: std_ulogic;
    oe_idu_to_uhlbus: std_ulogic;
    oe_wzreg_to_uhlbus: std_ulogic;
    oe_ubus_to_uhlbus: std_ulogic;
    oe_zreg_to_rbus: std_ulogic;
    wren_w: std_ulogic;
    wren_z: std_ulogic;
    wren_sp: std_ulogic;
    oe_idu_to_spreg: std_ulogic;
    oe_wzreg_to_spreg: std_ulogic;
    oe_spreg_to_idu: std_ulogic;
    oe_idu_to_pcreg: std_ulogic;
    wren_pc: std_ulogic;
  end record;

  function to_decoder_type(
    stage1: decoder_stage1_type;
    stage2: decoder_stage2_type;
    stage3: decoder_stage3_type
  ) return decoder_type;

  function to_stdulogicvector(x: decoder_stage1_type) return std_ulogic_vector;
  function to_stdulogicvector(x: decoder_stage2_type) return std_ulogic_vector;
  function to_stdulogicvector(x: decoder_stage3_type) return std_ulogic_vector;
  function to_stdulogicvector(x: decoder_type) return std_ulogic_vector;
end package;

package body sm83_decoder is
  function to_decoder_type(
    stage1: decoder_stage1_type;
    stage2: decoder_stage2_type;
    stage3: decoder_stage3_type
  ) return decoder_type is
    variable outputs: decoder_type;
  begin
    outputs.cb_00_to_3f := stage1.cb_00_to_3f;
    outputs.op_pop_sx10 := stage1.op_pop_sx10;
    outputs.op_ld_nn_sp_s010 := stage1.op_ld_nn_sp_s010;
    outputs.op_ld_nn_sp_s011 := stage1.op_ld_nn_sp_s011;
    outputs.op_rst_sx10 := stage1.op_rst_sx10;
    outputs.int_s110 := stage1.int_s110;
    outputs.op_di_ei_s0xx := stage1.op_di_ei_s0xx;
    outputs.op_halt_s0xx := stage1.op_halt_s0xx;
    outputs.op_nop_stop_s0xx := stage1.op_nop_stop_s0xx;
    outputs.op_cb_s0xx := stage1.op_cb_s0xx;

    outputs.cc_check := stage2.cc_check;
    outputs.oe_wzreg_to_idu := stage2.oe_wzreg_to_idu;
    outputs.op_jr_any_sx10 := stage2.op_jr_any_sx10;
    outputs.op_alu8 := stage2.op_alu8;
    outputs.wr := stage2.wr;
    outputs.m1 := stage2.m1;
    outputs.op_jr_any_sx01 := stage2.op_jr_any_sx01;
    outputs.op_sp_e_sx10 := stage2.op_sp_e_sx10;
    outputs.alu_res := stage2.alu_res;
    outputs.addr_valid := stage2.addr_valid;
    outputs.cb_bit := stage2.cb_bit;
    outputs.op_add_hl_sxx0 := stage2.op_add_hl_sxx0;
    outputs.op_incdec_rr := stage2.op_incdec_rr;
    outputs.op_ldh_imm_sx01 := stage2.op_ldh_imm_sx01;
    outputs.state0_next := stage2.state0_next;
    outputs.data_fetch_cycle := stage2.data_fetch_cycle;
    outputs.op_add_hl_sx01 := stage2.op_add_hl_sx01;
    outputs.op_push_sx10 := stage2.op_push_sx10;
    outputs.op_sp_e_s001 := stage2.op_sp_e_s001;
    outputs.alu_set := stage2.alu_set;
    outputs.addr_pc := stage2.addr_pc;
    outputs.oe_pchreg_to_pbus := stage2.oe_pchreg_to_pbus;
    outputs.op_ldh_c_sx00 := stage2.op_ldh_c_sx00;
    outputs.idu_inc := stage2.idu_inc;
    outputs.state2_next := stage2.state2_next;
    outputs.state1_next := stage2.state1_next;
    outputs.oe_pclreg_to_pbus := stage2.oe_pclreg_to_pbus;
    outputs.idu_dec := stage2.idu_dec;
    outputs.oe_wzreg_to_pcreg := stage2.oe_wzreg_to_pcreg;
    outputs.op_incdec8 := stage2.op_incdec8;

    outputs.alu_rotate_shift_left := stage3.alu_rotate_shift_left;
    outputs.alu_rotate_shift_right := stage3.alu_rotate_shift_right;
    outputs.alu_sum := stage3.alu_sum;
    outputs.alu_logic_or := stage3.alu_logic_or;
    outputs.alu_rlc := stage3.alu_rlc;
    outputs.alu_rl := stage3.alu_rl;
    outputs.alu_rrc := stage3.alu_rrc;
    outputs.alu_rr := stage3.alu_rr;
    outputs.alu_sra := stage3.alu_sra;
    outputs.alu_sum_pos_hf_cf := stage3.alu_sum_pos_hf_cf;
    outputs.alu_sum_neg_cf := stage3.alu_sum_neg_cf;
    outputs.alu_sum_neg_hf_nf := stage3.alu_sum_neg_hf_nf;
    outputs.oe_rbus_to_pbus := stage3.oe_rbus_to_pbus;
    outputs.alu_swap := stage3.alu_swap;
    outputs.alu_xor := stage3.alu_xor;
    outputs.alu_logic_and := stage3.alu_logic_and;
    outputs.alu_ccf_scf := stage3.alu_ccf_scf;
    outputs.alu_daa := stage3.alu_daa;
    outputs.alu_add_adc := stage3.alu_add_adc;
    outputs.alu_sub_sbc := stage3.alu_sub_sbc;
    outputs.alu_b_complement := stage3.alu_b_complement;
    outputs.alu_cpl := stage3.alu_cpl;
    outputs.alu_cp := stage3.alu_cp;
    outputs.wren_cf := stage3.wren_cf;
    outputs.wren_hf_nf_zf := stage3.wren_hf_nf_zf;
    outputs.op_dec8 := stage3.op_dec8;
    outputs.oe_areg_to_rbus := stage3.oe_areg_to_rbus;
    outputs.oe_alu_to_pbus := stage3.oe_alu_to_pbus;
    outputs.wren_a := stage3.wren_a;
    outputs.wren_h := stage3.wren_h;
    outputs.wren_l := stage3.wren_l;
    outputs.op_reti_s011 := stage3.op_reti_s011;
    outputs.oe_hlreg_to_idu := stage3.oe_hlreg_to_idu;
    outputs.oe_hreg_to_rbus := stage3.oe_hreg_to_rbus;
    outputs.oe_lreg_to_rbus := stage3.oe_lreg_to_rbus;
    outputs.oe_bcreg_to_idu := stage3.oe_bcreg_to_idu;
    outputs.oe_breg_to_rbus := stage3.oe_breg_to_rbus;
    outputs.oe_creg_to_rbus := stage3.oe_creg_to_rbus;
    outputs.wren_d := stage3.wren_d;
    outputs.wren_b := stage3.wren_b;
    outputs.wren_e := stage3.wren_e;
    outputs.wren_c := stage3.wren_c;
    outputs.oe_dereg_to_idu := stage3.oe_dereg_to_idu;
    outputs.oe_dreg_to_rbus := stage3.oe_dreg_to_rbus;
    outputs.oe_ereg_to_rbus := stage3.oe_ereg_to_rbus;
    outputs.oe_idu_to_uhlbus := stage3.oe_idu_to_uhlbus;
    outputs.oe_wzreg_to_uhlbus := stage3.oe_wzreg_to_uhlbus;
    outputs.oe_ubus_to_uhlbus := stage3.oe_ubus_to_uhlbus;
    outputs.oe_zreg_to_rbus := stage3.oe_zreg_to_rbus;
    outputs.wren_w := stage3.wren_w;
    outputs.wren_z := stage3.wren_z;
    outputs.wren_sp := stage3.wren_sp;
    outputs.oe_idu_to_spreg := stage3.oe_idu_to_spreg;
    outputs.oe_wzreg_to_spreg := stage3.oe_wzreg_to_spreg;
    outputs.oe_spreg_to_idu := stage3.oe_spreg_to_idu;
    outputs.oe_idu_to_pcreg := stage3.oe_idu_to_pcreg;
    outputs.wren_pc := stage3.wren_pc;

    return outputs;
  end function;

  function to_stdulogicvector(x: decoder_stage1_type) return std_ulogic_vector is
  begin
    return
      x.op_ld_nn_a_s010 &
      x.op_ld_a_nn_s010 &
      x.op_ld_a_nn_s011 &
      x.op_alu8 &
      x.op_jp_cc_sx01 &
      x.op_call_cc_sx01 &
      x.op_ret_cc_sx00 &
      x.op_jr_cc_sx00 &
      x.op_ldh_a_x &
      x.op_call_any_s000 &
      x.op_call_any_s001 &
      x.op_call_any_s010 &
      x.op_call_any_s011 &
      x.op_call_any_s100 &
      x.op_ld_x_n &
      x.op_ld_x_n_sx00 &
      x.op_ld_r_n_sx01 &
      x.op_s110 &
      x.op_s111 &
      x.op_jr_any_sx01 &
      x.op_jr_any_sx00 &
      x.op_add_sp_e_s010 &
      x.op_ld_hl_sp_sx10 &
      x.cb_res_r_sx00 &
      x.cb_res_hl_sx01 &
      x.op_rotate_a &
      x.op_ld_a_rr_sx01 &
      x.cb_bit &
      x.op_ld_rr_a_sx00 &
      x.op_ld_a_rr_sx00 &
      x.op_ldh_c_a_sx00 &
      x.op_ldh_n_a_sx00 &
      x.op_ldh_n_a_sx01 &
      x.op_ld_r_hl_sx00 &
      x.op_alu_misc_s0xx &
      x.op_add_hl_sxx0 &
      x.op_dec_rr_sx00 &
      x.op_inc_rr_sx00 &
      x.op_push_sx01 &
      x.op_push_sx00 &
      x.op_ld_r_r_s0xx &
      x.op_40_to_7f &
      x.cb_00_to_3f &
      x.op_jp_any_sx00 &
      x.op_jp_any_sx01 &
      x.op_jp_any_sx10 &
      x.op_add_hl_sx01 &
      x.op_ld_hl_n_sx01 &
      x.op_push_sx10 &
      x.op_pop_sx00 &
      x.op_pop_sx01 &
      x.op_add_sp_s001 &
      x.op_ld_hl_sp_sx01 &
      x.cb_set_r_sx00 &
      x.cb_set_hl_sx01 &
      x.cb_set_res_hl_sx00 &
      x.op_pop_sx10 &
      x.op_ldh_a_n_sx01 &
      x.op_ld_nn_sp_s010 &
      x.op_ld_nn_sp_s000 &
      x.op_ld_sp_hl_sx00 &
      x.op_add_sp_e_s000 &
      x.op_add_sp_e_s011 &
      x.op_ld_hl_sp_sx00 &
      x.op_ld_nn_sp_s011 &
      x.op_ld_nn_sp_s001 &
      x.op_ld_hl_r_sx00 &
      x.op_incdec8_hl_sx00 &
      x.op_incdec8_hl_sx01 &
      x.op_ldh_a_c_sx00 &
      x.op_ldh_a_n_sx00 &
      x.op_rst_sx01 &
      x.op_rst_sx00 &
      x.int_s101 &
      x.int_s100 &
      x.int_s000 &
      x.op_80_to_bf_reg_s0xx &
      x.op_ret_reti_sx00 &
      x.op_ret_cc_sx01 &
      x.op_jp_hl_s0xx &
      x.op_ret_any_reti_s010 &
      x.op_ret_any_reti_s011 &
      x.op_ld_hlinc_sx00 &
      x.op_ld_hldec_sx00 &
      x.op_ld_rr_sx00 &
      x.op_ld_rr_sx01 &
      x.op_ld_rr_sx10 &
      x.op_incdec8_s0xx &
      x.op_alu_hl_sx00 &
      x.op_alu_n_sx00 &
      x.op_rst_sx10 &
      x.int_s110 &
      x.cb_r_s0xx &
      x.cb_hl_sx00 &
      x.cb_bit_hl_sx01 &
      x.cb_notbit_hl_sx01 &
      x.op_incdec8 &
      x.op_di_ei_s0xx &
      x.op_halt_s0xx &
      x.op_nop_stop_s0xx &
      x.op_cb_s0xx &
      x.op_jr_any_sx10 &
      x.op_ea_fa_s000 &
      x.op_ea_fa_s001;
  end function;
  function to_stdulogicvector(x: decoder_stage2_type) return std_ulogic_vector is
  begin
    return
      x.cc_check &
      x.oe_wzreg_to_idu &
      x.op_jr_any_sx10 &
      x.op_alu8 &
      x.op_ld_abs_a_data_cycle &
      x.op_ld_a_abs_data_cycle &
      x.wr &
      x.op_jr_any_sx01 &
      x.op_sp_e_sx10 &
      x.alu_res &
      x.addr_valid &
      x.cb_bit &
      x.op_ld_abs_rr_sx00 &
      x.op_ldh_any_a_data_cycle &
      x.op_add_hl_sxx0 &
      x.op_incdec_rr &
      x.op_ldh_imm_sx01 &
      x.state0_next &
      x.data_fetch_cycle &
      x.op_add_hl_sx01 &
      x.op_push_sx10 &
      x.addr_hl &
      x.op_sp_e_s001 &
      x.alu_set &
      x.addr_pc &
      x.m1 &
      x.op_ld_nn_sp_s01x &
      x.oe_pchreg_to_pbus &
      x.op_ldh_c_sx00 &
      x.stackop &
      x.idu_inc &
      x.state2_next &
      x.state1_next &
      x.oe_pclreg_to_pbus &
      x.idu_dec &
      x.oe_wzreg_to_pcreg &
      x.op_incdec8 &
      x.allow_r8_write;
  end function;
  function to_stdulogicvector(x: decoder_stage3_type) return std_ulogic_vector is
  begin
    return
      x.alu_rotate_shift_left &
      x.alu_rotate_shift_right &
      x.alu_set_or &
      x.alu_sum &
      x.alu_logic_or &
      x.alu_rlc &
      x.alu_rl &
      x.alu_rrc &
      x.alu_rr &
      x.alu_sra &
      x.alu_sum_pos_hf_cf &
      x.alu_sum_neg_cf &
      x.alu_sum_neg_hf_nf &
      x.regpair_wren &
      x.alu_to_reg &
      x.oe_rbus_to_pbus &
      x.alu_swap &
      x.cb_20_to_3f &
      x.alu_xor &
      x.alu_logic_and &
      x.rotate &
      x.alu_ccf_scf &
      x.alu_daa &
      x.alu_add_adc &
      x.alu_sub_sbc &
      x.alu_b_complement &
      x.alu_cpl &
      x.alu_cp &
      x.wren_cf &
      x.wren_hf_nf_zf &
      x.op_add_sp_e_sx10 &
      x.op_add_sp_e_s001 &
      x.op_alu_misc_a &
      x.op_dec8 &
      x.alu_reg_to_rbus &
      x.oe_areg_to_rbus &
      x.cb_wren_r &
      x.oe_alu_to_pbus &
      x.wren_a &
      x.wren_h &
      x.wren_l &
      x.op_reti_s011 &
      x.oe_hlreg_to_idu &
      x.oe_hreg_to_rbus &
      x.oe_lreg_to_rbus &
      x.oe_dereg_to_idu &
      x.oe_dreg_to_rbus &
      x.oe_ereg_to_rbus &
      x.wren_d &
      x.wren_b &
      x.wren_e &
      x.wren_c &
      x.oe_bcreg_to_idu &
      x.oe_breg_to_rbus &
      x.oe_creg_to_rbus &
      x.oe_idu_to_uhlbus &
      x.oe_wzreg_to_uhlbus &
      x.oe_ubus_to_uhlbus &
      x.oe_zreg_to_rbus &
      x.wren_w &
      x.wren_z &
      x.wren_sp &
      x.oe_idu_to_spreg &
      x.oe_wzreg_to_spreg &
      x.op_ld_hl_sp_e_s010 &
      x.oe_spreg_to_idu &
      x.op_ld_hl_sp_e_s001 &
      x.oe_idu_to_pcreg &
      x.wren_pc;
  end function;
  function to_stdulogicvector(x: decoder_type) return std_ulogic_vector is
  begin
    return
      x.cb_00_to_3f &
      x.op_pop_sx10 &
      x.op_ld_nn_sp_s010 &
      x.op_ld_nn_sp_s011 &
      x.op_rst_sx10 &
      x.int_s110 &
      x.op_di_ei_s0xx &
      x.op_halt_s0xx &
      x.op_nop_stop_s0xx &
      x.op_cb_s0xx &
      x.cc_check &
      x.oe_wzreg_to_idu &
      x.op_jr_any_sx10 &
      x.op_alu8 &
      x.wr &
      x.m1 &
      x.op_jr_any_sx01 &
      x.op_sp_e_sx10 &
      x.alu_res &
      x.addr_valid &
      x.cb_bit &
      x.op_add_hl_sxx0 &
      x.op_incdec_rr &
      x.op_ldh_imm_sx01 &
      x.state0_next &
      x.data_fetch_cycle &
      x.op_add_hl_sx01 &
      x.op_push_sx10 &
      x.op_sp_e_s001 &
      x.alu_set &
      x.addr_pc &
      x.oe_pchreg_to_pbus &
      x.op_ldh_c_sx00 &
      x.idu_inc &
      x.state2_next &
      x.state1_next &
      x.oe_pclreg_to_pbus &
      x.idu_dec &
      x.oe_wzreg_to_pcreg &
      x.op_incdec8 &
      x.alu_rotate_shift_left &
      x.alu_rotate_shift_right &
      x.alu_sum &
      x.alu_logic_or &
      x.alu_rlc &
      x.alu_rl &
      x.alu_rrc &
      x.alu_rr &
      x.alu_sra &
      x.alu_sum_pos_hf_cf &
      x.alu_sum_neg_cf &
      x.alu_sum_neg_hf_nf &
      x.oe_rbus_to_pbus &
      x.alu_swap &
      x.alu_xor &
      x.alu_logic_and &
      x.alu_ccf_scf &
      x.alu_daa &
      x.alu_add_adc &
      x.alu_sub_sbc &
      x.alu_b_complement &
      x.alu_cpl &
      x.alu_cp &
      x.wren_cf &
      x.wren_hf_nf_zf &
      x.op_dec8 &
      x.oe_areg_to_rbus &
      x.oe_alu_to_pbus &
      x.wren_a &
      x.wren_h &
      x.wren_l &
      x.op_reti_s011 &
      x.oe_hlreg_to_idu &
      x.oe_hreg_to_rbus &
      x.oe_lreg_to_rbus &
      x.oe_dereg_to_idu &
      x.oe_dreg_to_rbus &
      x.oe_ereg_to_rbus &
      x.wren_d &
      x.wren_b &
      x.wren_e &
      x.wren_c &
      x.oe_bcreg_to_idu &
      x.oe_breg_to_rbus &
      x.oe_creg_to_rbus &
      x.oe_idu_to_uhlbus &
      x.oe_wzreg_to_uhlbus &
      x.oe_ubus_to_uhlbus &
      x.oe_zreg_to_rbus &
      x.wren_w &
      x.wren_z &
      x.wren_sp &
      x.oe_idu_to_spreg &
      x.oe_wzreg_to_spreg &
      x.oe_spreg_to_idu &
      x.oe_idu_to_pcreg &
      x.wren_pc;
  end function;
end package body;
