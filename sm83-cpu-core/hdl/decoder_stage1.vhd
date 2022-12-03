-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83_decoder.all;

-- Instruction decoder stage 1
entity decoder_stage1 is
  port (
    clk: in std_ulogic;
    intr: in std_ulogic;
    cb_mode: in std_ulogic;
    ir_reg: in std_ulogic_vector(7 downto 0);
    state: in std_ulogic_vector(2 downto 0);
    outputs: out decoder_stage1_type
  );
end entity;

-- Real hardware uses dynamic logic (precharge + NMOS transistors + static
-- output inverters), but for simplicity this model uses a simple "clk and"
-- condition instead
architecture asic of decoder_stage1 is
begin
  col_1_to_3: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 5) ?= "111";
    outputs.op_ld_nn_a_s010 <= t and ir_reg(4 downto 0) ?= "01010" and state ?= "010";
    outputs.op_ld_a_nn_s010 <= t and ir_reg(4 downto 0) ?= "11010" and state ?= "010";
    outputs.op_ld_a_nn_s011 <= t and ir_reg(4 downto 0) ?= "11010" and state ?= "011";
  end process;

  col_4: process(all)
    variable t, l, r: std_ulogic;
  begin
    t := clk and not intr and not cb_mode;
    l := t and ir_reg ?= "10------";
    r := t and ir_reg ?= "11---110";
    outputs.op_alu8 <= (l or r) and state ?= "---";
  end process;

  col_5_to_6: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 4) ?= "110-";
    outputs.op_jp_cc_sx01 <= t and ir_reg(3 downto 0) ?= "-010" and state ?= "-01";
    outputs.op_call_cc_sx01 <= t and ir_reg(3 downto 0) ?= "-100" and state ?= "-01";
  end process;

  col_7: process(all)
  begin
    outputs.op_ret_cc_sx00 <= clk and not intr and not cb_mode and ir_reg ?= "110--000" and state ?= "-00";
  end process;

  col_8: process(all)
  begin
    outputs.op_jr_cc_sx00 <= clk and not intr and not cb_mode and ir_reg ?= "001--000" and state ?= "-00";
  end process;

  col_9: process(all)
  begin
    outputs.op_ldh_a_x <= clk and not intr and not cb_mode and ir_reg ?= "111100-0" and state ?= "---";
  end process;

  col_10_to_14: process(all)
    variable t, l, r: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 5) ?= "110";
    l := t and ir_reg(4 downto 0) ?= "0110-";
    r := t and ir_reg(4 downto 0) ?= "--100";
    outputs.op_call_any_s000 <= (l or r) and state ?= "000";
    outputs.op_call_any_s001 <= (l or r) and state ?= "001";
    outputs.op_call_any_s010 <= (l or r) and state ?= "010";
    outputs.op_call_any_s011 <= (l or r) and state ?= "011";
    outputs.op_call_any_s100 <= (l or r) and state ?= "100";
  end process;

  col_15_to_17: process(all)
    variable t, l, r1, r2, r3: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "00";
    l := t and ir_reg(5 downto 0) ?= "---110";
    outputs.op_ld_x_n <= l and state ?= "---";
    outputs.op_ld_x_n_sx00 <= l and state ?= "-00";
    r1 := t and ir_reg(5 downto 3) ?= "--1";
    r2 := t and ir_reg(5 downto 3) ?= "-0-";
    r3 := t and ir_reg(5 downto 3) ?= "0--";
    outputs.op_ld_r_n_sx01 <= (r1 or r2 or r3) and ir_reg(2 downto 0) ?= "110" and state ?= "-01";
  end process;

  col_18: process(all)
  begin
    outputs.op_s110 <= clk and not intr and not cb_mode and ir_reg ?= "--------" and state ?= "110";
  end process;

  col_19: process(all)
  begin
    outputs.op_s111 <= clk and intr ?= '-' and cb_mode ?= '0' and ir_reg ?= "--------" and state ?= "111";
  end process;

  col_20_to_21: process(all)
    variable t, l, r: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "00";
    l := t and ir_reg(5 downto 0) ?= "1--000";
    r := t and ir_reg(5 downto 0) ?= "011000";
    outputs.op_jr_any_sx01 <= (l or r) and state ?= "-01";
    outputs.op_jr_any_sx00 <= (l or r) and state ?= "-00";
  end process;

  col_22: process(all)
  begin
    outputs.op_add_sp_e_s010 <= clk and not intr and not cb_mode and ir_reg ?= "11101000" and state ?= "010";
  end process;

  col_23: process(all)
  begin
    outputs.op_ld_hl_sp_sx10 <= clk and not intr and not cb_mode and ir_reg ?= "11111000" and state ?= "-10";
  end process;

  col_24_to_25: process(all)
    variable t, l1, l2, l3: std_ulogic;
  begin
    t := clk and not intr and cb_mode and ir_reg(7 downto 3) ?= "10---";
    l1 := t and ir_reg(2 downto 0) ?= "0--";
    l2 := t and ir_reg(2 downto 0) ?= "-0-";
    l3 := t and ir_reg(2 downto 0) ?= "--1";
    outputs.cb_res_r_sx00 <= (l1 or l2 or l3) and state ?= "-00";
    outputs.cb_res_hl_sx01 <= t and ir_reg(2 downto 0) ?= "110" and state ?= "-01";
  end process;

  col_26: process(all)
  begin
    outputs.op_rotate_a <= clk and not intr and not cb_mode and ir_reg ?= "000--111" and state ?= "---";
  end process;

  col_27: process(all)
  begin
    outputs.op_ld_a_rr_sx01 <= clk and not intr and not cb_mode and ir_reg ?= "00--1010" and state ?= "-01";
  end process;

  col_28: process(all)
  begin
    outputs.cb_bit <= clk and not intr and cb_mode and ir_reg ?= "01------" and state ?= "---";
  end process;

  col_29_to_30: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 4) ?= "00--";
    outputs.op_ld_rr_a_sx00 <= t and ir_reg(3 downto 0) ?= "0010" and state ?= "-00";
    outputs.op_ld_a_rr_sx00 <= t and ir_reg(3 downto 0) ?= "1010" and state ?= "-00";
  end process;

  col_31_to_33: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 2) ?= "111000";
    outputs.op_ldh_c_a_sx00 <= t and ir_reg(1 downto 0) ?= "10" and state ?= "-00";
    outputs.op_ldh_n_a_sx00 <= t and ir_reg(1 downto 0) ?= "00" and state ?= "-00";
    outputs.op_ldh_n_a_sx01 <= t and ir_reg(1 downto 0) ?= "00" and state ?= "-01";
  end process;

  col_34: process(all)
    variable t, s1, c2, c3: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 7) ?= "0";
    s1 := t and ir_reg(6 downto 3) ?= "10--";
    c2 := t and ir_reg(6 downto 3) ?= "1-0-";
    c3 := t and ir_reg(6 downto 3) ?= "1--1";
    outputs.op_ld_r_hl_sx00 <= (s1 or c2 or c3) and ir_reg(2 downto 0) ?= "110" and state ?= "-00";
  end process;

  col_35: process(all)
  begin
    outputs.op_alu_misc_s0xx <= clk and not intr and not cb_mode and ir_reg ?= "00---111" and state ?= "0--";
  end process;

  col_36_to_38: process(all)
    variable t, l: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 4) ?= "00--";
    l := t and ir_reg(3 downto 2) ?= "10";
    outputs.op_add_hl_sxx0 <= l and ir_reg(1 downto 0) ?= "01" and state ?= "--0";
    outputs.op_dec_rr_sx00 <= l and ir_reg(1 downto 0) ?= "11" and state ?= "-00";
    outputs.op_inc_rr_sx00 <= t and ir_reg(3 downto 0) ?= "0011" and state ?= "-00";
  end process;

  col_39_to_40: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg ?= "11--0101";
    outputs.op_push_sx01 <= t and state ?= "-01";
    outputs.op_push_sx00 <= t and state ?= "-00";
  end process;

  col_41: process(all)
    variable t, u1, u2, u3, l1, l2, l3: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "01";
    u1 := t and ir_reg(5 downto 3) ?= "0--";
    u2 := t and ir_reg(5 downto 3) ?= "-0-";
    u3 := t and ir_reg(5 downto 3) ?= "--1";
    l1 := (u1 or u2 or u3) and ir_reg(2 downto 0) ?= "--1";
    l2 := (u1 or u2 or u3) and ir_reg(2 downto 0) ?= "-0-";
    l3 := (u1 or u2 or u3) and ir_reg(2 downto 0) ?= "0--";
    outputs.op_ld_r_r_s0xx <= (l1 or l2 or l3) and state ?= "0--";
  end process;

  col_42: process(all)
  begin
    outputs.op_40_to_7f <= clk and not intr and not cb_mode and ir_reg ?= "01------" and state ?= "---";
  end process;

  col_43: process(all)
  begin
    outputs.cb_00_to_3f <= clk and not intr and cb_mode and ir_reg ?= "00------" and state ?= "---";
  end process;

  col_44_to_46: process(all)
    variable t, l, r: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 5) ?= "110";
    l := t and ir_reg(4 downto 0) ?= "0001-";
    r := t and ir_reg(4 downto 0) ?= "--010";
    outputs.op_jp_any_sx00 <= (l or r) and state ?= "-00";
    outputs.op_jp_any_sx01 <= (l or r) and state ?= "-01";
    outputs.op_jp_any_sx10 <= (l or r) and state ?= "-10";
  end process;

  col_47_to_48: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "00";
    outputs.op_add_hl_sx01 <= t and ir_reg(5 downto 0) ?= "--1001" and state ?= "-01";
    outputs.op_ld_hl_n_sx01 <= t and ir_reg(5 downto 0) ?= "110110" and state ?= "-01";
  end process;

  -- col 49-50 are invalid because they both have the same impossible condition: state(0) ?= '0' and state(0) ?= '1'

  col_51_to_53: process(all)
    variable t, r: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 3) ?= "11--0";
    r := t and ir_reg(2 downto 0) ?= "001" and state(2 downto 1) ?= "-0";
    outputs.op_push_sx10 <= t and ir_reg(2 downto 0) ?= "101" and state ?= "-10";
    outputs.op_pop_sx00 <= r and state(0 downto 0) ?= "0";
    outputs.op_pop_sx01 <= r and state(0 downto 0) ?= "1";
  end process;

  col_54: process(all)
  begin
    outputs.op_add_sp_s001 <= clk and not intr and not cb_mode and ir_reg ?= "11101000" and state ?= "001";
  end process;

  col_55: process(all)
  begin
    outputs.op_ld_hl_sp_sx01 <= clk and not intr and not cb_mode and ir_reg ?= "11111000" and state ?= "-01";
  end process;

  col_56: process(all)
    variable t, l1, l2, r: std_ulogic;
  begin
    t := clk and not intr and cb_mode and ir_reg(7 downto 4) ?= "11--";
    l1 := t and ir_reg(3 downto 0) ?= "-0--";
    l2 := t and ir_reg(3 downto 0) ?= "--0-";
    r := t and ir_reg(3 downto 0) ?= "---1";
    outputs.cb_set_r_sx00 <= (l1 or l2 or r) and state ?= "-00";
  end process;

  col_57_to_58: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and cb_mode and ir_reg(7 downto 7) ?= "1";
    outputs.cb_set_hl_sx01 <= t and ir_reg(6 downto 0) ?= "1---110" and state ?= "-01";
    outputs.cb_set_res_hl_sx00 <= t and ir_reg(6 downto 0) ?= "----110" and state ?= "-00";
  end process;

  col_59: process(all)
  begin
    outputs.op_pop_sx10 <= clk and not intr and not cb_mode and ir_reg ?= "11--0001" and state ?= "-10";
  end process;

  col_60: process(all)
  begin
    outputs.op_ldh_a_n_sx01 <= clk and not intr and not cb_mode and ir_reg ?= "11110000" and state ?= "-01";
  end process;

  col_61_to_62: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg ?= "00001000";
    outputs.op_ld_nn_sp_s010 <= t and state ?= "010";
    outputs.op_ld_nn_sp_s000 <= t and state ?= "000";
  end process;

  col_63_to_66: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "11";
    outputs.op_ld_sp_hl_sx00 <= t and ir_reg(5 downto 0) ?= "111001" and state ?= "-00";
    outputs.op_add_sp_e_s000 <= t and ir_reg(5 downto 0) ?= "101000" and state ?= "000";
    outputs.op_add_sp_e_s011 <= t and ir_reg(5 downto 0) ?= "101000" and state ?= "011";
    outputs.op_ld_hl_sp_sx00 <= t and ir_reg(5 downto 0) ?= "111000" and state ?= "-00";
  end process;

  col_67_to_68: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg ?= "00001000" and state(2 downto 2) ?= "0";
    outputs.op_ld_nn_sp_s011 <= t and state(1 downto 0) ?= "11";
    outputs.op_ld_nn_sp_s001 <= t and state(1 downto 0) ?= "01";
  end process;

  col_69: process(all)
    variable t, s1, c2, c3: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 3) ?= "01110";
    s1 := t and ir_reg(2 downto 0) ?= "--1";
    c2 := t and ir_reg(2 downto 0) ?= "-0-";
    c3 := t and ir_reg(2 downto 0) ?= "0--";
    outputs.op_ld_hl_r_sx00 <= (s1 or c2 or c3) and state ?= "-00";
  end process;

  col_70_to_71: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg ?= "0011010-";
    outputs.op_incdec8_hl_sx00 <= t and state ?= "-00";
    outputs.op_incdec8_hl_sx01 <= t and state ?= "-01";
  end process;

  col_72_to_73: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 2) ?= "111100";
    outputs.op_ldh_a_c_sx00 <= t and ir_reg(1 downto 0) ?= "10" and state ?= "-00";
    outputs.op_ldh_a_n_sx00 <= t and ir_reg(1 downto 0) ?= "00" and state ?= "-00";
  end process;

  col_74_to_75: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg ?= "11---111" and state(2 downto 2) ?= "-";
    outputs.op_rst_sx01 <= t and state(1 downto 0) ?= "01";
    outputs.op_rst_sx00 <= t and state(1 downto 0) ?= "00";
  end process;

  col_76_to_78: process(all)
    variable t: std_ulogic;
  begin
    t := clk and intr and not cb_mode and ir_reg ?= "--------";
    outputs.int_s101 <= t and state ?= "101";
    outputs.int_s100 <= t and state ?= "100";
    outputs.int_s000 <= t and state ?= "000";
  end process;

  col_79: process(all)
    variable t, s1, c2, c3: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 3) ?= "10---";
    s1 := t and ir_reg(2 downto 0) ?= "-0-";
    c2 := t and ir_reg(2 downto 0) ?= "0--";
    c3 := t and ir_reg(2 downto 0) ?= "--1";
    outputs.op_80_to_bf_reg_s0xx <= (s1 or c2 or c3) and state ?= "0--";
  end process;

  col_80_to_81: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 4) ?= "110-";
    outputs.op_ret_reti_sx00 <= t and ir_reg(3 downto 0) ?= "1001" and state ?= "-00";
    outputs.op_ret_cc_sx01 <= t and ir_reg(3 downto 0) ?= "-000" and state ?= "-01";
  end process;

  col_82: process(all)
  begin
    outputs.op_jp_hl_s0xx <= clk and not intr and not cb_mode and ir_reg ?= "11101001" and state ?= "0--";
  end process;

  col_83_to_84: process(all)
    variable t, s1, c2: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 4) ?= "110-";
    s1 := t and ir_reg(3 downto 0) ?= "100-";
    c2 := t and ir_reg(3 downto 0) ?= "-000";
    outputs.op_ret_any_reti_s010 <= (s1 or c2) and state ?= "010";
    outputs.op_ret_any_reti_s011 <= (s1 or c2) and state ?= "011";
  end process;

  col_85_to_86: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "00";
    outputs.op_ld_hlinc_sx00 <= t and ir_reg(5 downto 0) ?= "10-010" and state ?= "-00";
    outputs.op_ld_hldec_sx00 <= t and ir_reg(5 downto 0) ?= "11-010" and state ?= "-00";
  end process;

  col_87_to_89: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg ?= "00--0001";
    outputs.op_ld_rr_sx00 <= t and state ?= "-00";
    outputs.op_ld_rr_sx01 <= t and state ?= "-01";
    outputs.op_ld_rr_sx10 <= t and state ?= "-10";
  end process;

  col_90: process(all)
    variable t, s1, c2, c3: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "00";
    s1 := t and ir_reg(5 downto 3) ?= "--1";
    c2 := t and ir_reg(5 downto 3) ?= "-0-";
    c3 := t and ir_reg(5 downto 3) ?= "0--";
    outputs.op_incdec8_s0xx <= (s1 or c2 or c3) and ir_reg(2 downto 0) ?= "10-" and state ?= "0--";
  end process;

  col_91: process(all)
  begin
    outputs.op_alu_hl_sx00 <= clk and not intr and not cb_mode and ir_reg ?= "10---110" and state ?= "-00";
  end process;

  col_92: process(all)
  begin
    outputs.op_alu_n_sx00 <= clk and not intr and not cb_mode and ir_reg ?= "11---110" and state ?= "-00";
  end process;

  col_93: process(all)
  begin
    outputs.op_rst_sx10 <= clk and not intr and not cb_mode and ir_reg ?= "11---111" and state ?= "-10";
  end process;

  col_94: process(all)
  begin
    outputs.int_s110 <= clk and intr and not cb_mode and ir_reg ?= "--------" and state ?= "110";
  end process;

  col_95: process(all)
    variable t, s1, c2, c3: std_ulogic;
  begin
    t := clk and not intr and cb_mode and ir_reg(7 downto 3) ?= "-----";
    s1 := t and ir_reg(2 downto 0) ?= "--1";
    c2 := t and ir_reg(2 downto 0) ?= "0--";
    c3 := t and ir_reg(2 downto 0) ?= "-0-";
    outputs.cb_r_s0xx <= (s1 or c2 or c3) and state ?= "0--";
  end process;

  col_96: process(all)
  begin
    outputs.cb_hl_sx00 <= clk and not intr and cb_mode and ir_reg ?= "-----110" and state ?= "-00";
  end process;

  col_97: process(all)
  begin
    outputs.cb_bit_hl_sx01 <= clk and not intr and cb_mode and ir_reg ?= "01---110" and state ?= "-01";
  end process;

  col_98: process(all)
  begin
    outputs.cb_notbit_hl_sx01 <= clk and not intr and cb_mode and ir_reg ?= "-0---110" and state ?= "-01";
  end process;

  col_99: process(all)
  begin
    outputs.op_incdec8 <= clk and not intr and not cb_mode and ir_reg ?= "00---10-" and state ?= "---";
  end process;

  col_100: process(all)
  begin
    outputs.op_di_ei_s0xx <= clk and not intr and not cb_mode and ir_reg ?= "1111-011" and state ?= "0--";
  end process;

  col_101: process(all)
  begin
    outputs.op_halt_s0xx <= clk and not intr and not cb_mode and ir_reg ?= "01110110" and state ?= "0--";
  end process;

  col_102: process(all)
  begin
    outputs.op_nop_stop_s0xx <= clk and not intr and not cb_mode and ir_reg ?= "000-0000" and state ?= "0--";
  end process;

  col_103: process(all)
  begin
    outputs.op_cb_s0xx <= clk and not intr and not cb_mode and ir_reg ?= "11001011" and state ?= "0--";
  end process;

  col_104: process(all)
    variable t, l, r: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg(7 downto 6) ?= "00";
    l := t and ir_reg(5 downto 0) ?= "011000";
    r := t and ir_reg(5 downto 0) ?= "1--000";
    outputs.op_jr_any_sx10 <= (l or r) and state ?= "-10";
  end process;

  col_105_to_106: process(all)
    variable t: std_ulogic;
  begin
    t := clk and not intr and not cb_mode and ir_reg ?= "111-1010";
    outputs.op_ea_fa_s000 <= t and state ?= "000";
    outputs.op_ea_fa_s001 <= t and state ?= "001";
  end process;

  -- col 107 is invalid because it has an impossible condition: state(0) ?= '0' and state(0) ?= '1'
end architecture;
