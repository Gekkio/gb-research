-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83.all;
use work.sm83_decoder.all;

-- SM83 CPU core
entity cpu_core is
  port (
    reset_async: in std_ulogic;
    reset_sync: in std_ulogic;
    clk: in std_ulogic;
    mclk_pulse: in std_ulogic;
    phi: in std_ulogic;
    writeback: in std_ulogic;
    writeback_ext: in std_ulogic;
    boot_en: in std_ulogic;
    fexx_ffxx: in std_ulogic;
    test_t1: in std_ulogic;
    test_t2: in std_ulogic;
    reset_ack: in std_ulogic;
    wake: in std_ulogic;
    nmi: in std_ulogic;
    irq: in std_ulogic_vector(7 downto 0);
    data: inout std_ulogic_vector(7 downto 0);
    irq_ack: out std_ulogic_vector(7 downto 0);
    m1: out std_ulogic;
    wr: out std_ulogic;
    rd: out std_ulogic;
    memrq: out std_ulogic;
    addr: out std_ulogic_vector(15 downto 0);
    cpuclk_en: out std_ulogic;
    sysclk_en: out std_ulogic
  );
end entity;

architecture asic of cpu_core is
  signal p_bus: std_logic_vector(7 downto 0);
  signal r_bus: std_ulogic_vector(7 downto 0);
  signal q_bus: std_ulogic_vector(7 downto 0);
  signal alu_out: std_ulogic_vector(7 downto 0);

  signal idu_out: std_ulogic_vector(15 downto 0);
  signal idu_in: std_ulogic_vector(15 downto 0);

  signal decoder: decoder_type;

  signal ir_reg: std_ulogic_vector(7 downto 0);
  signal z_reg: std_ulogic_vector(7 downto 0);

  signal a_reg_hi_9bdf: std_ulogic;
  signal a_reg_lo_gt_9: std_ulogic;
  signal a_reg_hi_gt_9: std_ulogic;

  signal cc_match: std_ulogic;
  signal z_reg_sign: std_ulogic;
  signal flags: cpu_flags;
  signal carry: std_ulogic;

  signal intr: std_ulogic;
  signal cb_mode: std_ulogic;
  signal state: std_ulogic_vector(2 downto 0);
  signal data_lsb: std_ulogic;

  signal nmi_dispatch: std_ulogic;
  signal intr_addr: std_ulogic_vector(7 downto 3);
  signal intr_wake: std_ulogic;
  signal irq_req: std_ulogic;
begin
  io_cell_gen: for i in 0 to 7 generate
    io_cell_inst: entity work.io_cell
    port map (
      clk => clk,
      ext_data => data(i),
      test_t1 => test_t1,
      int_data => p_bus(i),
      alu_data => alu_out(i),
      alu_data_oe => decoder.oe_alu_to_pbus
    );
  end generate;

  decoder_inst: entity work.decoder
  port map (
    clk => clk,
    phi => phi,
    writeback => writeback,
    intr => intr,
    cb_mode => cb_mode,
    ir_reg => ir_reg,
    state => state,
    data_lsb => data_lsb,
    outputs => decoder
  );

  m1 <= decoder.m1;
  wr <= decoder.wr;

  alu_inst: entity work.alu
  port map (
    clk => clk,
    phi => phi,
    writeback => writeback,
    writeback_ext => writeback_ext,
    decoder => decoder,
    a_reg_hi_9bdf => a_reg_hi_9bdf,
    a_reg_lo_gt_9 => a_reg_lo_gt_9,
    a_reg_hi_gt_9 => a_reg_hi_gt_9,
    cc_match => cc_match,
    z_reg_sign => z_reg_sign,
    carry => carry,
    flags => flags,
    ir_reg => ir_reg,
    z_reg => z_reg(7 downto 4),
    q_bus => q_bus,
    r_bus => r_bus,
    data_out => alu_out
  );

  r_bus_to_p_bus_gen: for i in 0 to 7 generate
    p_bus(i) <= '0' when not r_bus(i) and decoder.oe_rbus_to_pbus else 'Z';
  end generate;

  regfile_inst: entity work.regfile
  port map (
    reset_sync => reset_sync,
    clk => clk,
    writeback => writeback,
    writeback_ext => writeback_ext,
    flags => flags,
    z_reg_sign => z_reg_sign,
    intr_addr => intr_addr,
    p_bus => p_bus,
    q_bus => q_bus,
    r_bus => r_bus,
    alu_out => alu_out,
    idu_out => idu_out,
    idu_in => idu_in,
    a_reg_hi_9bdf => a_reg_hi_9bdf,
    a_reg_lo_gt_9 => a_reg_lo_gt_9,
    a_reg_hi_gt_9 => a_reg_hi_gt_9,
    ir_reg => ir_reg,
    z_reg => z_reg,
    decoder => decoder
  );

  idu_inst: entity work.idu
  port map (
    phi => phi,
    decoder => decoder,
    carry => carry,
    z_sign => z_reg(7),
    data_in => idu_in,
    data_out => idu_out
  );

  -- address bus output buffer
  addr <= X"ZZZZ" when test_t1 else idu_in;

  control_unit_inst: entity work.control_unit
  port map (
    reset_async => reset_async,
    reset_sync => reset_sync,
    clk => clk,
    mclk_pulse => mclk_pulse,
    phi => phi,
    writeback => writeback,
    test_t1 => test_t1,
    test_t2 => test_t2,
    boot_en => boot_en,
    fexx_ffxx => fexx_ffxx,
    nmi => nmi,
    wake => wake,
    reset_ack => reset_ack,
    decoder => decoder,
    cc_match => cc_match,
    intr_wake => intr_wake,
    irq_req => irq_req,
    ir_reg => ir_reg,
    state => state,
    cb_mode => cb_mode,
    intr => intr,
    data_lsb => data_lsb,
    nmi_dispatch => nmi_dispatch,
    rd => rd,
    memrq => memrq,
    cpuclk_en => cpuclk_en,
    sysclk_en => sysclk_en
  );

  interrupts_inst: entity work.interrupts
  port map (
    reset_sync => reset_sync,
    phi => phi,
    writeback => writeback,
    addr => addr,
    data => p_bus,
    wr => wr,
    rd => rd,
    irq => irq,
    nmi_dispatch => nmi_dispatch,
    int_s110 => decoder.int_s110,
    intr_addr => intr_addr,
    intr_wake => intr_wake,
    irq_ack => irq_ack,
    irq_req => irq_req
  );
end architecture;
