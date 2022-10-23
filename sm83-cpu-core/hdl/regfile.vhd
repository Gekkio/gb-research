-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83.all;
use work.sm83_decoder.all;

entity regfile is
  port (
    reset_sync: in std_ulogic;
    clk: in std_ulogic;
    writeback: in std_ulogic;
    writeback_ext: in std_ulogic;
    flags: in cpu_flags;
    z_reg_sign: in std_ulogic;
    intr_addr: in std_ulogic_vector(7 downto 3);
    p_bus: inout std_logic_vector(7 downto 0);
    q_bus: out std_ulogic_vector(7 downto 0);
    r_bus: out std_ulogic_vector(7 downto 0);
    alu_out: in std_ulogic_vector(7 downto 0);
    idu_out: in std_ulogic_vector(15 downto 0);
    idu_in: out std_ulogic_vector(15 downto 0);
    ir_reg: out std_ulogic_vector(7 downto 0);
    z_reg: out std_ulogic_vector(7 downto 0);
    a_reg_hi_9bdf: out std_ulogic;
    a_reg_lo_gt_9: out std_ulogic;
    a_reg_hi_gt_9: out std_ulogic;
    decoder: in decoder_type
  );
end entity;

architecture asic of regfile is
  signal nq_bus: std_logic_vector(7 downto 0);
  signal nr_bus: std_logic_vector(7 downto 0);
  signal nuh_bus: std_logic_vector(7 downto 0);
  signal nul_bus: std_logic_vector(7 downto 0);

  signal nidu_in: std_logic_vector(15 downto 0);

  signal uh_bus: std_ulogic_vector(7 downto 0);
  signal ul_bus: std_ulogic_vector(7 downto 0);

  signal a_reg: std_ulogic_vector(7 downto 0);
  signal l_reg: std_ulogic_vector(7 downto 0);
  signal h_reg: std_ulogic_vector(7 downto 0);
  signal c_reg: std_ulogic_vector(7 downto 0);
  signal b_reg: std_ulogic_vector(7 downto 0);
  signal e_reg: std_ulogic_vector(7 downto 0);
  signal d_reg: std_ulogic_vector(7 downto 0);
  signal w_reg: std_ulogic_vector(7 downto 0);
  signal sp_reg: std_ulogic_vector(15 downto 0);
  signal pc_reg: std_ulogic_vector(15 downto 0);

  -- register pairs for convenience
  signal bc_reg: std_ulogic_vector(15 downto 0);
  signal de_reg: std_ulogic_vector(15 downto 0);
  signal hl_reg: std_ulogic_vector(15 downto 0);
  signal wz_reg: std_ulogic_vector(15 downto 0);

  signal sp_e_adjust: std_ulogic;
  signal oe_freg_to_rbus: std_ulogic;
  signal z_reg_in_mux: std_ulogic;
  signal w_reg_in_mux: std_ulogic;

  signal z_reg_in: std_ulogic_vector(7 downto 0);
  signal w_reg_in: std_ulogic_vector(7 downto 0);
  signal sp_reg_in: std_logic_vector(15 downto 0);
  signal pc_reg_in: std_logic_vector(15 downto 0);
begin
  -- ADON
  a_reg_hi_9bdf <= a_reg(7) and a_reg(4);
  -- ALYP
  a_reg_hi_gt_9 <= a_reg(7) and (a_reg(6) or a_reg(5));
  -- AHEE
  a_reg_lo_gt_9 <= a_reg(3) and (a_reg(2) or a_reg(1));

  sp_e_adjust <= decoder.op_sp_e_sx10 and z_reg_sign;
  oe_freg_to_rbus <= decoder.op_push_sx10 and ir_reg(5 downto 4) ?= "11";

  -- TODO: actual precharge
  p_bus <= X"HH";
  nr_bus <= X"HH";
  nq_bus <= X"HH";
  nul_bus <= X"HH";
  nuh_bus <= X"HH";

  nr_bus <= X"00" when clk and sp_e_adjust else X"ZZ";
  q_bus <= not nq_bus;
  r_bus <= not nr_bus;
  ul_bus <= not nul_bus;
  uh_bus <= not nuh_bus;

  nr_bus(4) <= '0' when flags.carry and oe_freg_to_rbus and clk else 'Z';
  nr_bus(5) <= '0' when flags.half_carry and oe_freg_to_rbus and clk else 'Z';
  nr_bus(6) <= '0' when flags.add_subtract and oe_freg_to_rbus and clk else 'Z';
  nr_bus(7) <= '0' when flags.zero and oe_freg_to_rbus and clk else 'Z';

  nq_bus <= X"00" when decoder.op_dec8 else X"ZZ";

  out_gen: for i in 0 to 7 generate
    nq_bus(i) <= '0' when a_reg(i) and decoder.op_alu8 else 'Z';
    nr_bus(i) <= '0' when a_reg(i) and decoder.oe_areg_to_rbus else 'Z';

    nq_bus(i) <= '0' when l_reg(i) and decoder.op_add_hl_sxx0 else 'Z';
    nr_bus(i) <= '0' when l_reg(i) and decoder.oe_lreg_to_rbus else 'Z';

    nq_bus(i) <= '0' when h_reg(i) and decoder.op_add_hl_sx01 else 'Z';
    nr_bus(i) <= '0' when h_reg(i) and decoder.oe_hreg_to_rbus else 'Z';

    nr_bus(i) <= '0' when c_reg(i) and decoder.oe_creg_to_rbus else 'Z';

    nr_bus(i) <= '0' when b_reg(i) and decoder.oe_breg_to_rbus else 'Z';

    nr_bus(i) <= '0' when e_reg(i) and decoder.oe_ereg_to_rbus else 'Z';

    nr_bus(i) <= '0' when d_reg(i) and decoder.oe_dreg_to_rbus else 'Z';

    nr_bus(i) <= '0' when not z_reg(i) and decoder.oe_zreg_to_rbus else 'Z';

    nul_bus(i) <= '0' when idu_out(i) and decoder.oe_idu_to_uhlbus else 'Z';
    nul_bus(i) <= '0' when not z_reg(i) and decoder.oe_wzreg_to_uhlbus else 'Z';
    nul_bus(i) <= '0' when alu_out(i) and decoder.oe_ubus_to_uhlbus else 'Z';

    nuh_bus(i) <= '0' when idu_out(8+i) and decoder.oe_idu_to_uhlbus else 'Z';
    nuh_bus(i) <= '0' when not w_reg(i) and decoder.oe_wzreg_to_uhlbus else 'Z';
    nuh_bus(i) <= '0' when alu_out(i) and decoder.oe_ubus_to_uhlbus else 'Z';

    p_bus(i) <= '0' when not sp_reg(i) and decoder.op_ld_nn_sp_s010 else 'Z';
    nq_bus(i) <= '0' when sp_reg(i) and decoder.op_sp_e_s001 else 'Z';
    nr_bus(i) <= '0' when sp_reg(i) and decoder.op_add_hl_sxx0 and ir_reg(5 downto 4) ?= "11" else 'Z';

    p_bus(i) <= '0' when not sp_reg(8+i) and decoder.op_ld_nn_sp_s011 else 'Z';
    nq_bus(i) <= '0' when sp_reg(8+i) and decoder.op_sp_e_sx10 else 'Z';
    nr_bus(i) <= '0' when sp_reg(8+i) and decoder.op_add_hl_sx01 and ir_reg(5 downto 4) ?= "11" else 'Z';

    p_bus(i) <= '0' when not pc_reg(i) and decoder.oe_pclreg_to_pbus else 'Z';
    nq_bus(i) <= '0' when pc_reg(i) and decoder.op_jr_any_sx01 else 'Z';

    p_bus(i) <= '0' when not pc_reg(8+i) and decoder.oe_pchreg_to_pbus else 'Z';
  end generate;


  nidu_in <= X"HHHH";
  nidu_in(15 downto 8) <= X"00" when decoder.op_ldh_imm_sx01 else X"ZZ";
  nidu_in(15 downto 8) <= X"00" when decoder.op_ldh_c_sx00 else X"ZZ";

  nidu_in_gen_lsb: for i in 0 to 7 generate
    nidu_in(i) <= '0' when not z_reg(i) and decoder.op_ldh_imm_sx01 else 'Z';
  end generate;

  nidu_in_gen_msb: for i in 8 to 15 generate
    nidu_in(i) <= '0' when pc_reg(i) and decoder.op_jr_any_sx01 else 'Z';
  end generate;

  nidu_in_gen_16: for i in 0 to 15 generate
    nidu_in(i) <= '0' when hl_reg(i) and decoder.oe_hlreg_to_idu else 'Z';
    nidu_in(i) <= '0' when bc_reg(i) and decoder.oe_bcreg_to_idu else 'Z';
    nidu_in(i) <= '0' when de_reg(i) and decoder.oe_dereg_to_idu else 'Z';
    nidu_in(i) <= '0' when not wz_reg(i) and decoder.oe_wzreg_to_idu else 'Z';
    nidu_in(i) <= '0' when not wz_reg(i) and decoder.op_jr_any_sx10 else 'Z';
    nidu_in(i) <= '0' when pc_reg(i) and decoder.addr_pc else 'Z';
    nidu_in(i) <= '0' when sp_reg(i) and decoder.oe_spreg_to_idu else 'Z';
  end generate;

  idu_in <= not nidu_in;


  z_reg_in_mux <= decoder.op_ld_nn_sp_s010;
  z_reg_in <= (not p_bus) when not z_reg_in_mux else (not idu_out(7 downto 0));

  w_reg_in_mux <= decoder.op_ld_nn_sp_s010 or decoder.op_jr_any_sx01;
  w_reg_in <= (not p_bus) when not w_reg_in_mux else (not idu_out(15 downto 8));

  sp_reg_in_gen: for i in 0 to 15 generate
    sp_reg_in(i) <= '0' when not wz_reg(i) and decoder.oe_wzreg_to_spreg and writeback else 'Z';
    sp_reg_in(i) <= '0' when idu_out(i) and decoder.oe_idu_to_spreg and writeback else 'Z';
  end generate;
  sp_reg_in <= (others => '1') when not writeback_ext else (others => 'H');

  pc_reg_in_gen: for i in 0 to 15 generate
    pc_reg_in(i) <= '0' when not wz_reg(i) and decoder.oe_wzreg_to_pcreg and writeback else 'Z';
    pc_reg_in(i) <= '0' when idu_out(i) and decoder.oe_idu_to_pcreg and writeback else 'Z';
  end generate;
  pc_reg_in(3) <= '0' when ir_reg(3) and decoder.op_rst_sx10 and writeback else 'Z';
  pc_reg_in(4) <= '0' when ir_reg(4) and decoder.op_rst_sx10 and writeback else 'Z';
  pc_reg_in(5) <= '0' when ir_reg(5) and decoder.op_rst_sx10 and writeback else 'Z';
  pc_reg_in(3) <= '0' when intr_addr(3) and writeback else 'Z';
  pc_reg_in(4) <= '0' when intr_addr(4) and writeback else 'Z';
  pc_reg_in(5) <= '0' when intr_addr(5) and writeback else 'Z';
  pc_reg_in(6) <= '0' when intr_addr(6) and writeback else 'Z';
  pc_reg_in(7) <= '0' when intr_addr(7) and writeback else 'Z';
  pc_reg_in <= (others => '1') when not writeback_ext else (others => 'H');

  ir_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.m1,
    en => writeback,
    d => p_bus,
    q => ir_reg
  );
  a_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_a,
    en => writeback,
    d => uh_bus,
    q => a_reg
  );
  l_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_l,
    en => writeback,
    d => ul_bus,
    q => l_reg
  );
  h_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_h,
    en => writeback,
    d => uh_bus,
    q => h_reg
  );
  e_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_e,
    en => writeback,
    d => ul_bus,
    q => e_reg
  );
  d_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_d,
    en => writeback,
    d => uh_bus,
    q => d_reg
  );
  c_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_c,
    en => writeback,
    d => ul_bus,
    q => c_reg
  );
  b_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_b,
    en => writeback,
    d => uh_bus,
    q => b_reg
  );
  z_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_z,
    en => writeback,
    d => z_reg_in,
    q => z_reg
  );
  w_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => decoder.wren_w,
    en => writeback,
    d => w_reg_in,
    q => w_reg
  );
  hl_reg <= h_reg & l_reg;
  de_reg <= d_reg & e_reg;
  bc_reg <= b_reg & c_reg;
  wz_reg <= w_reg & z_reg;

  sp_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 16)
  port map (
    clk => decoder.wren_sp,
    en => writeback,
    d => sp_reg_in,
    nq => sp_reg
  );

  pc_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 16)
  port map (
    clk => decoder.wren_pc,
    en => writeback,
    set => reset_sync,
    d => pc_reg_in,
    nq => pc_reg
  );
end architecture;
