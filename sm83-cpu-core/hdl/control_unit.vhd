-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83.all;
use work.sm83_decoder.all;

-- Control unit
entity control_unit is
  port (
    reset_async: in std_ulogic;
    reset_sync: in std_ulogic;
    clk: in std_ulogic;
    mclk_pulse: in std_ulogic;
    phi: in std_ulogic;
    writeback: in std_ulogic;
    test_t1: in std_ulogic;
    test_t2: in std_ulogic;
    boot_en: in std_ulogic;
    fexx_ffxx: in std_ulogic;
    nmi: in std_ulogic;
    wake: in std_ulogic;
    reset_ack: in std_ulogic;
    decoder: in decoder_type;
    cc_match: in std_ulogic;
    intr_wake: in std_ulogic;
    irq_req: in std_ulogic;
    ir_reg: in std_ulogic_vector(7 downto 0);
    state: out std_ulogic_vector(2 downto 0);
    cb_mode: out std_ulogic;
    intr: out std_ulogic;
    data_lsb: out std_ulogic;
    nmi_dispatch: out std_ulogic;
    rd: out std_ulogic;
    memrq: out std_ulogic;
    cpuclk_en: out std_ulogic;
    sysclk_en: out std_ulogic
  );
end entity;

architecture asic of control_unit is
  signal reset_op_int: std_ulogic;
  -- unused, fixed connection to GND
  signal reset_op_ext: std_ulogic := '0';
  signal op_stop: std_ulogic;
  signal reset_any: std_ulogic;
  signal halt_req, stop_req, intr_wake_sync: std_ulogic;
  signal cpuclk_shdn, sysclk_shdn: std_ulogic;

  signal cb_instr_exec: std_ulogic;

  signal data_msb: std_ulogic;
  signal data_fetch_lsb: std_ulogic;

  signal cpuclk_shdn_req: std_ulogic;
  signal cpuclk_wake_req: std_ulogic;
  signal ime: std_ulogic;
  signal ime_reset_n: std_ulogic;
  signal ime_set: std_ulogic;
  signal intr_ack: std_ulogic;
  signal intr_dispatch: std_ulogic;
  signal intr_trigger: std_ulogic;
  signal irq_begin: std_ulogic;
  signal irq_en_n: std_ulogic;
  signal irq_ready_n: std_ulogic;
  signal irq_trigger: std_ulogic;
  signal nmi_ack: std_ulogic;
  signal nmi_begin: std_ulogic;
  signal nmi_en: std_ulogic;
  signal nmi_ready: std_ulogic;
  signal nmi_n: std_ulogic;
  signal nmi_posedge: std_ulogic;
  signal nmi_prev_delayed: std_ulogic;
  signal nmi_prev_n: std_ulogic;
  signal nmi_req: std_ulogic;
  signal nmi_trigger: std_ulogic;
  signal nmi_trigger_n: std_ulogic;
  signal op_boundary: std_ulogic;
  signal op_di: std_ulogic;
  signal op_di_n: std_ulogic;
  signal reset_sync_n: std_ulogic;
  signal startup_begin: std_ulogic;
  signal startup_delay_m0: std_ulogic;
  signal startup_delay_m1: std_ulogic;
  signal startup_delay_m2: std_ulogic;
  signal sysclk_wake_req: std_ulogic;
begin
  -- WAFR, WDIN, WYRP
  rd <= (decoder.m1 or decoder.data_fetch_cycle) and not (test_t1 or phi);

  -- ZLYZ
  memrq <= decoder.addr_valid and ((not boot_en and not fexx_ffxx) or (test_t2 and not fexx_ffxx));

  -- XOGS
  op_boundary <= (decoder.m1 and not phi and not decoder.op_cb_s0xx) or reset_op_int; -- includes XULT

  -- ==== cpuclk control

  -- YSBT
  halt_req_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => decoder.op_halt_s0xx,
    q => halt_req
  );

  -- YNOZ
  cpuclk_shdn_req <= halt_req or stop_req or reset_async;

  -- YOII
  intr_wake_sync_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => intr_wake,
    q => intr_wake_sync
  );

  -- YKUA
  cpuclk_wake_req <= not ((intr_wake_sync or startup_begin) and not reset_any);

  -- YNKW
  cpuclk_shdn_inst: entity work.srlatch
  port map (
    s => cpuclk_shdn_req,
    nr => cpuclk_wake_req,
    q => cpuclk_shdn
  );

  -- XWEE
  cpuclk_en <= not cpuclk_shdn;

  -- ==== sysclk control

  -- ZIUL
  op_stop <= decoder.op_nop_stop_s0xx and ir_reg(4);

  -- ZKAI
  stop_req_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => op_stop,
    q => stop_req
  );

  -- ZWLM
  sysclk_wake_req <= wake nor reset_any;

  -- ZUMN
  sysclk_shdn_inst: entity work.srlatch
  port map (
    s => stop_req,
    nr => sysclk_wake_req,
    q => sysclk_shdn
  );

  -- ZBJV
  sysclk_en <= not sysclk_shdn;

  -- ==== reset signals

  -- YCNF
  reset_op_int <= cpuclk_shdn or reset_sync or reset_op_ext;

  -- ZKON, ZHZO
  reset_any <= reset_sync or reset_async;

  -- ZUDN
  reset_sync_n <= not reset_sync;

  -- ZIKS
  startup_delay_m0 <= reset_ack nand reset_sync_n;

  -- ZORP
  startup_delay_m1_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => startup_delay_m0,
    q => startup_delay_m1
  );

  -- ZAZA
  startup_delay_m2_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => startup_delay_m1,
    q => startup_delay_m2
  );

  -- YOLU
  startup_begin <= startup_delay_m1 nor (not startup_delay_m2);

  -- ==== decoder intr flag

  -- XYGB
  intr <= intr_dispatch or reset_op_int or reset_op_ext;

  -- ==== decoder cb_mode flag

  -- XURG
  cb_instr_exec_inst: entity work.ssdff
  port map (
    clk => decoder.m1,
    en => writeback,
    res => cpuclk_shdn,
    d => decoder.op_cb_s0xx,
    q => cb_instr_exec
  );

  -- XUDO, XTIP
  cb_mode <= (cb_instr_exec and not state(2)) or reset_op_ext;

  -- ==== 3-bit decoder state

  -- XAYM
  state0_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    -- WAGR + WUDZ
    d => decoder.state0_next or cc_match or reset_op_int,
    q => state(0)
  );

  -- XIRF
  state1_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    -- WAGR + WEEN
    d => decoder.state1_next or cc_match or reset_op_int,
    q => state(1)
  );

  -- XUFU
  state2_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    -- WAGR + WERF
    d => decoder.state2_next or cc_match or reset_op_int,
    q => state(2)
  );

  -- ==== data MSB/LSB toggle

  -- VILE
  data_lsb <= not data_msb;

  -- VEQU
  data_fetch_lsb <= decoder.data_fetch_cycle and data_lsb;

  -- XDQF
  data_msb_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => data_fetch_lsb,
    q => data_msb
  );

  -- ==== general interrupt control signals

  -- ZACW
  intr_dispatch_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => intr_trigger,
    q => intr_dispatch
  );

  -- ZFEX
  intr_trigger <= irq_trigger or nmi_trigger;

  -- ZOWA
  intr_ack <= decoder.int_s110 nor reset_sync;

  -- ==== NMI machinery

  -- YEPJ
  nmi_n <= not nmi;

  -- YDXA
  nmi_prev_n_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => nmi_n,
    q => nmi_prev_n
  );

  -- YODP
  nmi_prev_delayed_inst: entity work.dlatch
  port map (
    clk => not mclk_pulse,
    d => nmi_prev_n,
    nq => nmi_prev_delayed
  );

  -- YNIU: detect when nmi was previously low and is now high
  nmi_posedge <= nmi_prev_delayed nor nmi_n;

  -- ZOJZ
  nmi_req_inst: entity work.srlatch
  port map (
    s => nmi_posedge,
    nr => nmi_ack,
    q => nmi_req
  );

  -- ZYOC
  nmi_begin <= nmi_req and nmi_ready and op_boundary;

  -- ZLOZ
  nmi_trigger_inst: entity work.srlatch
  port map (
    s => nmi_begin,
    nr => nmi_ack,
    q => nmi_trigger
  );

  -- ZRBY
  nmi_dispatch_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => nmi_trigger,
    q => nmi_dispatch
  );

  -- YNEU
  nmi_ack <= not ((decoder.int_s110 and nmi_dispatch) or reset_sync);

  -- ZGNA
  nmi_trigger_n <= not nmi_trigger;

  -- ZRSY
  nmi_en_inst: entity work.srlatch
  port map (
    -- ZDNA
    s => (reset_sync or decoder.op_reti_s011),
    nr => nmi_trigger_n,
    q => nmi_en
  );

  -- ZKDU
  nmi_ready_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => nmi_en,
    q => nmi_ready
  );

  -- ==== IRQ machinery

  -- ZZOM
  op_di_n <= (not ir_reg(3)) nand decoder.op_di_ei_s0xx; -- includes ZEVO

  -- ZMIZ
  op_di <= not op_di_n;

  -- ZBPP
  ime_set <= (
    (decoder.op_reti_s011 and nmi_ready) or -- "returning from maskable irq"
    (decoder.op_di_ei_s0xx and ir_reg(3))
  ) and not phi;

  -- ZWUU
  ime_reset_n <= not (
    (
      (
        (intr_dispatch and nmi_ready) or -- "dispatching maskable irq"
        (decoder.op_di_ei_s0xx and not ir_reg(3)) -- includes ZEVO
      ) and not phi
    ) or reset_sync
  );

  -- ZJJE
  ime_inst: entity work.srlatch
  port map (
    s => ime_set,
    nr => ime_reset_n,
    q => ime
  );

  -- ZOXC
  irq_en_n <= nmi_en nand ime;

  -- ZIVV
  irq_ready_n_inst: entity work.dff
  port map (
    clk => not clk,
    d => irq_en_n,
    q => irq_ready_n
  );

  -- ZAIJ
  -- similar to nmi_begin: !irq_ready_n and op_boundary and irq_req and !op_di
  irq_begin <= not (
    irq_ready_n or
    (op_boundary nand irq_req) or -- includes ZAOC
    op_di or
    phi -- includes ZELP, redundant due to op_boundary
  );

  -- ZKOG
  irq_trigger_inst: entity work.srlatch
  port map (
    s => irq_begin,
    nr => intr_ack,
    q => irq_trigger
  );
end architecture;
