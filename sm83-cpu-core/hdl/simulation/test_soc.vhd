-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library sm83;
use sm83.sm83_test.all;

entity test_soc is
  port (
    clk: in std_ulogic;
    reset: in std_ulogic;
    irq: in std_ulogic_vector(7 downto 0) := (others => '0');
    nmi: in std_ulogic := '0';
    addr: out std_ulogic_vector(15 downto 0);
    data: inout std_logic_vector(7 downto 0);
    bus_ctrl: out soc_bus_ctrl_type;
    boot_en: out std_ulogic := '1';
    m1: out std_ulogic;
    clocks: out clocks_type
  );
end entity;

architecture tb of test_soc is
  signal clocks_gen: clocks_type;

  signal reset_async: std_ulogic := '1';
  signal reset_sync: std_ulogic := '1';
  signal fexx_ffxx: std_ulogic;
  signal test_t1: std_ulogic := '0';
  signal test_t2: std_ulogic :='0';
  signal reset_ack: std_ulogic := '0';
  signal wake: std_ulogic := '0';
  signal irq_ack: std_ulogic_vector(7 downto 0);
  signal wr: std_ulogic;
  signal rd: std_ulogic;
  signal memrq: std_ulogic;
  signal cpuclk_en: std_ulogic;
  signal sysclk_en: std_ulogic;

  signal if_reg: std_ulogic_vector(4 downto 0) := (others => '0');
  signal if_write: std_ulogic := '0';

  signal wram_cs: std_ulogic;
  signal hram_cs: std_ulogic;
begin
  -- Emulate SoC bus precharge with weak pullups
  data <= (others => 'H');

  fexx_ffxx <= '1' when addr >= X"FE00" else '0';

  clocks.clk <= clocks_gen.clk when cpuclk_en = '1' else '0';
  clocks.phi <= clocks_gen.phi when cpuclk_en = '1' else '0';
  clocks.writeback <= clocks_gen.writeback when cpuclk_en = '1' else '0';
  clocks.writeback_ext <= clocks_gen.writeback_ext when cpuclk_en = '1' else '0';
  clocks.mclk_pulse <= clocks_gen.mclk_pulse when sysclk_en = '1' else '1';

  process(all)
    constant SEQ_CLK: std_ulogic_vector(0 to 7) := "01111111";
    constant SEQ_PHI: std_ulogic_vector(0 to 7) := "11110000";
    constant SEQ_MCLK_PULSE: std_ulogic_vector(0 to 7) := "10000000";
    constant SEQ_WRITEBACK: std_ulogic_vector(0 to 7) := "00000011";
    constant SEQ_WRITEBACK_EXT: std_ulogic_vector(0 to 7) := "10000011";

    variable clk_counter: unsigned(2 downto 0) := (others => '0');
  begin
    if clk'event then
      clk_counter := clk_counter + 1;
    end if;
    clocks_gen.clk <= SEQ_CLK(to_integer(clk_counter));
    clocks_gen.phi <= SEQ_PHI(to_integer(clk_counter));
    clocks_gen.mclk_pulse <= SEQ_MCLK_PULSE(to_integer(clk_counter));
    clocks_gen.writeback <= SEQ_WRITEBACK(to_integer(clk_counter));
    clocks_gen.writeback_ext <= SEQ_WRITEBACK_EXT(to_integer(clk_counter));
  end process;

  core_inst: entity sm83.cpu_core
  port map (
    reset_async => reset_async,
    reset_sync => reset_sync,
    clk => clocks.clk,
    mclk_pulse => clocks.mclk_pulse,
    phi => clocks.phi,
    writeback => clocks.writeback,
    writeback_ext => clocks.writeback_ext,
    boot_en => boot_en,
    fexx_ffxx => fexx_ffxx,
    test_t1 => test_t1,
    test_t2 => test_t2,
    reset_ack => reset_ack,
    wake => wake,
    nmi => nmi,
    irq => "000" & if_reg,
    data => data,
    irq_ack => irq_ack,
    m1 => m1,
    wr => wr,
    rd => rd,
    memrq => memrq,
    addr => addr,
    cpuclk_en => cpuclk_en,
    sysclk_en => sysclk_en
  );

  bus_ctrl.wr <= wr and clocks.writeback;
  bus_ctrl.rd <= rd;
  bus_ctrl.addr <= addr;

  wram_cs <= '1' when addr >= X"C000" and addr < X"E000" else '0';
  wram_inst: entity sm83.async_ram
  generic map (addr_bits => 13)
  port map (
    bus_ctrl => bus_ctrl,
    cs => wram_cs,
    data => data
  );

  hram_cs <= '1' when addr >= X"FF80" else '0';
  hram_inst: entity sm83.async_ram
  generic map (addr_bits => 7)
  port map (
    bus_ctrl => bus_ctrl,
    cs => hram_cs,
    data => data
  );

  fake_boot_rom: process(all)
  begin
    data <= X"ZZ";
    if rd and boot_en then
      if addr ?= X"0100" then
        boot_en <= '0';
      else
        case addr(2 downto 0) is
          when "000" => data <= X"C3"; -- JP
          when "001" => data <= X"00"; -- lsb(0x0100)
          when "010" => data <= X"01"; -- msb(0x0100)
          when others => data <= X"00";
        end case;
      end if;
    end if;
  end process;

  if_write <= bus_ctrl.wr and addr ?= X"FF0F";
  if_reg_impl: process(all)
  begin
    data <= X"ZZ";
    if rd then
      if addr ?= X"FF0F" then
        data <= "111" & if_reg;
      end if;
    end if;
    for i in if_reg'range loop
      if irq_ack(i) then
        if_reg(i) <= '0';
      elsif if_write then
        if_reg(i) <= data(i);
      end if;
    end loop;
  end process;

  process(all)
    variable reset_in: std_ulogic := '1';
  begin
    if rising_edge(clocks.mclk_pulse) then
      reset_sync <= reset_in;
    end if;
    if reset then
      reset_in := '1';
    elsif reset_ack then
      reset_in := '0';
    end if;
    reset_async <= reset_in or reset_sync;
  end process;

  process(all)
    variable warmup: boolean := false;
  begin
    if warmup and rising_edge(clocks.mclk_pulse) then
      reset_ack <= '1';
    end if;
    if reset or not sysclk_en then
      warmup := true;
    elsif cpuclk_en then
      warmup := false;
    end if;
  end process;
end architecture;
