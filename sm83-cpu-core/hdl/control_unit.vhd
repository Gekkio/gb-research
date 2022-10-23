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
    intr_trigger: in std_ulogic;
    irq_trigger: in std_ulogic;
    ir_reg: in std_ulogic_vector(7 downto 0);
    state: out std_ulogic_vector(2 downto 0);
    cb_mode: out std_ulogic;
    intr_dispatch: out std_ulogic;
    data_lsb: out std_ulogic;
    nmi_trigger: out std_ulogic;
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
  signal halt_req, stop_req, intr_req: std_ulogic;
  signal cpuclk_shdn, sysclk_shdn: std_ulogic;

  signal xurg: std_ulogic;

  signal xdqf, vequ, vile: std_ulogic;

  signal xogs, ykua, yolu: std_ulogic;
  signal ynoz, yneu, yepj, ydxa: std_ulogic;
  signal yodp, yniu, zaza, zorp: std_ulogic;
  signal ziks, zwlm, zudn, zloz: std_ulogic;
  signal zyoc, zojz, zacw, zfex: std_ulogic;
  signal zkog, zowa, zaoc, zzom: std_ulogic;
  signal zmiz, zepl, zaij, zivv: std_ulogic;
  signal zkdu, zgna, znda, zrsy: std_ulogic;
  signal zoxc, zwuu, zjje, zbpp: std_ulogic;
begin
  -- WAFR, WDIN, WYRP
  rd <= (decoder.m1 or decoder.data_fetch_cycle) and not (test_t1 or phi);

  -- ZLYZ
  memrq <= decoder.addr_valid and ((not boot_en and not fexx_ffxx) or (test_t2 and not fexx_ffxx));

  -- XWEE
  cpuclk_en <= not cpuclk_shdn;

  -- ZBJV
  sysclk_en <= not sysclk_shdn;

  -- ==== decoder intr_dispatch flag

  -- XYGB
  intr_dispatch <= zacw or reset_op_int or reset_op_ext;

  -- ==== decoder cb_mode flag

  xurg_inst: entity work.ssdff
  port map (
    clk => decoder.m1,
    en => writeback,
    res => cpuclk_shdn,
    d => decoder.op_cb_s0xx,
    q => xurg
  );

  -- XUDO, XTIP
  cb_mode <= (xurg and not state(2)) or reset_op_ext;

  -- ==== 3-bit decoder state

  xaym_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    -- WAGR + WUDZ
    d => decoder.state0_next or cc_match or reset_op_int,
    q => state(0)
  );

  xirf_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    -- WAGR + WEEN
    d => decoder.state1_next or cc_match or reset_op_int,
    q => state(1)
  );

  xufu_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    -- WAGR + WERF
    d => decoder.state2_next or cc_match or reset_op_int,
    q => state(2)
  );

  -- ==== data MSB/LSB toggle

  vile <= not xdqf;
  vequ <= decoder.data_fetch_cycle and vile;

  xdqf_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => vequ,
    q => xdqf
  );

  data_lsb <= vile;

  -- ==== uncategorized

  xogs <= (decoder.m1 and not phi and not decoder.op_cb_s0xx) or reset_op_int; -- includes XULT

  yoii_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => intr_trigger,
    q => intr_req
  );

  ykua <= not ((intr_req or yolu) and not reset_any);

  yolu <= zorp nor (not zaza);

  ysbt_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => decoder.op_halt_s0xx,
    q => halt_req
  );

  ynoz <= halt_req or stop_req or reset_async;

  ynkw_inst: entity work.srlatch
  port map (
    s => ynoz,
    nr => ykua,
    q => cpuclk_shdn
  );

  -- YCNF
  reset_op_int <= cpuclk_shdn or reset_sync or reset_op_ext;

  yneu <= not ((decoder.int_s110 and nmi_trigger) or reset_sync);

  yepj <= not nmi;

  ydxa_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => yepj,
    q => ydxa
  );

  yodp_inst: entity work.dlatch
  port map (
    clk => not mclk_pulse,
    d => ydxa,
    nq => yodp
  );

  yniu <= yodp nor yepj;

  zaza_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => zorp,
    q => zaza
  );

  zorp_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => ziks,
    q => zorp
  );

  ziks <= reset_ack nand zudn;

  zwlm <= wake nor reset_any;

  zumn_inst: entity work.srlatch
  port map (
    s => stop_req,
    nr => zwlm,
    q => sysclk_shdn
  );

  zkai_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => op_stop,
    q => stop_req
  );

  -- ZIUL
  op_stop <= decoder.op_nop_stop_s0xx and ir_reg(4);

  zudn <= not reset_sync;

  zrby_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => zloz,
    q => nmi_trigger
  );

  zloz_inst: entity work.srlatch
  port map (
    s => zyoc,
    nr => yneu,
    q => zloz
  );

  zyoc <= zojz and zkdu and xogs;

  zojz_inst: entity work.srlatch
  port map (
    s => yniu,
    nr => yneu,
    q => zojz
  );

  zacw_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => zfex,
    q => zacw
  );

  zfex <= zkog or zloz;

  zkog_inst: entity work.srlatch
  port map (
    s => zaij,
    nr => zowa,
    q => zkog
  );

  zowa <= decoder.int_s110 nor reset_sync;

  zaoc <= xogs nand irq_trigger;

  zzom <= (not ir_reg(3)) nand decoder.op_di_ei_s0xx; -- includes ZEVO

  zmiz <= not zzom;

  zaij <= not (zivv or zaoc or zmiz or phi); -- includes ZELP

  zivv_inst: entity work.dff
  port map (
    clk => not clk,
    d => zoxc,
    q => zivv
  );

  zkdu_inst: entity work.dff
  port map (
    clk => mclk_pulse,
    d => zrsy,
    q => zkdu
  );

  zgna <= not zloz;

  znda <= reset_sync or decoder.op_reti_s011;

  zrsy_inst: entity work.srlatch
  port map (
    s => znda,
    nr => zgna,
    q => zrsy
  );

  zoxc <= zrsy nand zjje;

  zwuu <= not (
    (
      (
        (zacw and zkdu) or
        (decoder.op_di_ei_s0xx and not ir_reg(3)) -- includes ZEVO
      ) and not phi
    ) or reset_sync
  );

  zjje_inst: entity work.srlatch
  port map (
    s => zbpp,
    nr => zwuu,
    q => zjje
  );

  zbpp <= (
    (decoder.op_reti_s011 and zkdu) or
    (decoder.op_di_ei_s0xx and ir_reg(3))
  ) and not phi;

  -- ZKON, ZHZO
  reset_any <= reset_sync or reset_async;
end architecture;
