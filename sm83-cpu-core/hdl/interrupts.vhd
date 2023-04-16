-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sm83.all;

entity interrupts is
  port (
    reset_sync: in std_ulogic;
    phi: in std_ulogic;
    writeback: in std_ulogic;
    addr: in std_ulogic_vector(15 downto 0);
    data: inout std_ulogic_vector(7 downto 0);
    wr: in std_ulogic;
    rd: in std_ulogic;
    irq: in std_ulogic_vector(7 downto 0);
    nmi_dispatch: in std_ulogic;
    int_s110: in std_ulogic;
    intr_addr: out std_ulogic_vector(7 downto 3);
    intr_wake: out std_ulogic;
    irq_ack: out std_ulogic_vector(7 downto 0);
    irq_req: out std_ulogic
  );
end entity;

architecture asic of interrupts is
  signal irq_latch: std_ulogic_vector(7 downto 0);
  signal irq_prio: std_ulogic_vector(7 downto 0);

  signal ie_reg: std_ulogic_vector(7 downto 0);

  signal addr_ffff: std_ulogic;
  signal wren_ie: std_ulogic;
begin
  addr_ffff <= '1' when addr ?= X"FFFF" else '0';
  wren_ie <= addr_ffff and wr;

  ie_reg_inst: entity work.ssdff_vector
  generic map (WIDTH => 8)
  port map (
    clk => wren_ie,
    en => writeback,
    res => reset_sync,
    d => data,
    q => ie_reg
  );

  ie_reg_gen: for i in 0 to 7 generate
    data(i) <= '0' when not ie_reg(i) and addr_ffff and rd else 'Z';
  end generate;

  intr_wake <= (or irq_latch) or nmi_dispatch;
  irq_ack <= irq_prio and int_s110;

  intr_addr(3) <= writeback and (irq_ack(1) or irq_ack(3) or irq_ack(5) or irq_ack(7));
  intr_addr(4) <= writeback and (irq_ack(2) or irq_ack(3) or irq_ack(6) or irq_ack(7));
  intr_addr(5) <= writeback and (irq_ack(4) or irq_ack(6) or irq_ack(7));
  intr_addr(6) <= int_s110 and irq_req;
  intr_addr(7) <= int_s110 and nmi_dispatch;

  irq_latch_gen: for i in 0 to 7 generate
    irq_latch_inst: entity work.dlatch
    port map (
      clk => phi,
      d => irq(i) nand ie_reg(i),
      nq => irq_latch(i)
    );
  end generate;

  -- In real hardware, these signals actually use dynamic logic with writeback as the clock
  irq_prio(0) <= '1' when irq_latch ?= "-------1" and not nmi_dispatch and writeback else '0';
  irq_prio(1) <= '1' when irq_latch ?= "------10" and not nmi_dispatch and writeback else '0';
  irq_prio(2) <= '1' when irq_latch ?= "-----100" and not nmi_dispatch and writeback else '0';
  irq_prio(3) <= '1' when irq_latch ?= "----1000" and not nmi_dispatch and writeback else '0';
  irq_prio(4) <= '1' when irq_latch ?= "---10000" and not nmi_dispatch and writeback else '0';
  irq_prio(5) <= '1' when irq_latch ?= "--100000" and not nmi_dispatch and writeback else '0';
  irq_prio(6) <= '1' when irq_latch ?= "-1000000" and not nmi_dispatch and writeback else '0';
  irq_prio(7) <= '1' when irq_latch ?= "10000000" and not nmi_dispatch and writeback else '0';

  irq_req <= or(irq_prio) and writeback;
end architecture;
