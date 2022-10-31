-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use std.textio.all;

library vunit_lib;
context vunit_lib.vunit_context;

library sm83;
use sm83.sm83_test.all;

entity test_rom_tb is
  generic(
    runner_cfg: string;
    rom_path: string := "test.gb";
    terminate_on_ld_b_b: boolean := false;
    terminate_on_infinite_jr: boolean := true;
    terminate_on_infinite_jp: boolean := true;
    max_instruction_count: natural := 100_000_000;
    max_duration: time := 60_000 ms
  );
end entity;

architecture tb of test_rom_tb is
  signal rom_data: integer_array_t;
  signal rom_bank: std_ulogic_vector(7 downto 0) := X"01";

  signal clk: std_ulogic := '1';
  signal reset: std_ulogic := '1';

  signal clocks: clocks_type;
  signal bus_ctrl: soc_bus_ctrl_type;
  signal data: std_logic_vector(7 downto 0);
  signal boot_en: std_ulogic;
  signal m1: std_ulogic;
begin
  main: process
    variable stored_addr: std_ulogic_vector(15 downto 0);
    variable stored_data: std_ulogic_vector(7 downto 0);

    variable instruction_count: natural := 0;
  begin
    test_runner_setup(runner, runner_cfg);

    rom_data <= load_raw(rom_path, 8, false);

    wait until rising_edge(clocks.mclk_pulse);
    reset <= '0' after 10 ns;
    wait until rising_edge(clocks.mclk_pulse);

    loop
      if instruction_count >= max_instruction_count then
        info("Terminating: max instruction count reached");
        exit;
      end if;
      wait until rising_edge(m1);
      wait until bus_ctrl.rd;
      wait until data'stable(10 ns);
      if stored_addr ?= bus_ctrl.addr then
        if terminate_on_infinite_jr and to_ux01(data) = X"18" then
          info("Terminating: infinite JR loop");
          exit;
        elsif terminate_on_infinite_jp and to_ux01(data) = X"C3" then
          info("Terminating: infinite JP loop");
          exit;
        elsif terminate_on_ld_b_b and to_ux01(data) = X"40" then
          info("Terminating: LD B, B");
          exit;
        end if;
      end if;
      stored_addr := bus_ctrl.addr;
      stored_data := data;
      wait until rising_edge(clocks.mclk_pulse);
      instruction_count := instruction_count + 1;
    end loop;

    info("Executed " & to_string(instruction_count) & " instructions");

    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, max_duration);

  clk <= not clk after 119.2 ns;

  soc_inst: entity work.test_soc
  port map (
    clk => clk,
    reset => reset,
    clocks => clocks,
    bus_ctrl => bus_ctrl,
    data => data,
    boot_en => boot_en,
    m1 => m1
  );

  external_rom: process(all)
  begin
    data <= X"ZZ";
    if bus_ctrl.rd and not boot_en then
      if bus_ctrl.addr < X"4000" then
        data <= read_array(rom_data, bus_ctrl.addr);
      elsif bus_ctrl.addr < X"8000" then
        data <= read_array(rom_data, rom_bank & bus_ctrl.addr(13 downto 0));
      end if;
    end if;

    if rising_edge(bus_ctrl.wr) then
      if bus_ctrl.addr >= X"2000" and bus_ctrl.addr < X"2FFF" then
        rom_bank <= data;
      end if;
    end if;
  end process;

  serial: process(all)
  begin
    data <= X"ZZ";
    if bus_ctrl.rd then
      if bus_ctrl.addr ?= X"FF02" then
        data <= X"7F";
      end if;
    end if;
    if rising_edge(bus_ctrl.wr) then
      if bus_ctrl.addr ?= X"FF01" then
        info("SB: " & to_ascii(data) & "(0x" & to_hex_string(data) & ")");
      end if;
    end if;
  end process;
end architecture;
