-- SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity mbc1b_tb is
  generic(runner_cfg: string);
end entity;

architecture tb of mbc1b_tb is
  subtype addr_type is std_ulogic_vector(15 downto 0);
  subtype data_type is std_ulogic_vector(7 downto 0);
  subtype aa_type is std_ulogic_vector(14 downto 13);
  subtype ra_type is std_ulogic_vector(18 downto 14);

  type inputs_type is record
    addr: addr_type;
    data: data_type;
    cs_n: std_ulogic;
    rd_n: std_ulogic;
    reset_n: std_ulogic;
    wr_n: std_ulogic;
  end record;

  signal inputs: inputs_type := (
    addr => (others => '0'),
    data => (others => '0'),
    cs_n => '1',
    rd_n => '1',
    reset_n => '0',
    wr_n => '1'
  );

  type outputs_type is record
    aa: aa_type;
    ra: ra_type;
    ram_cs: std_ulogic;
    ram_cs_n: std_ulogic;
    rom_cs_n: std_ulogic;
  end record;

  signal outputs: outputs_type;

  procedure check_outputs(expected: outputs_type) is
  begin
    wait for 1 us;
    check_equal(outputs.aa, expected.aa, result("for AA"));
    check_equal(outputs.ra, expected.ra, result("for RA"));
    check_equal(outputs.ram_cs, expected.ram_cs, result("for RAM_CS"));
    check_equal(outputs.ram_cs_n, expected.ram_cs_n, result("for nRAM_CS"));
    check_equal(outputs.rom_cs_n, expected.rom_cs_n, result("for nROM_CS"));
  end procedure;

  procedure write(signal drv: out inputs_type; test_addr: addr_type; test_data: data_type) is
  begin
    drv.addr <= test_addr;
    drv.addr(15) <= '1';
    wait for 1 us;
    drv.addr(15) <= '0';
    wait for 1 us;
    drv.data <= test_data;
    drv.wr_n <= '0';
    wait for 1 us;
    drv.wr_n <= '1';
    wait for 1 us;
    drv.addr(15) <= '1';
  end procedure;

  procedure test_rom_read(signal drv: out inputs_type; test_addr: addr_type; expected_aa: aa_type; expected_ra: ra_type) is
  begin
    drv.addr <= test_addr;
    drv.addr(15) <= '1';
    check_outputs((aa => expected_aa, ra => expected_ra, ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
    drv.rd_n <= '0';
    check_outputs((aa => expected_aa, ra => expected_ra, ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
    drv.addr(15) <= '0';
    check_outputs((aa => expected_aa, ra => expected_ra, ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));
    drv.rd_n <= '1';
    drv.addr(15) <= '1';
    wait for 1 us;
  end procedure;

  procedure test_ram_read(signal drv: out inputs_type; test_addr: addr_type; expected_aa: aa_type; expected_ra: ra_type; expected_ram_cs: std_ulogic) is
  begin
    drv.addr <= test_addr;
    check_outputs((aa => expected_aa, ra => expected_ra, ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
    drv.rd_n <= '0';
    check_outputs((aa => expected_aa, ra => expected_ra, ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
    drv.cs_n <= '0';
    check_outputs((aa => expected_aa, ra => expected_ra, ram_cs => expected_ram_cs, ram_cs_n => not expected_ram_cs, rom_cs_n => '1'));
    drv.rd_n <= '1';
    drv.cs_n <= '1';
    wait for 1 us;
  end procedure;
begin
  main: process
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      inputs.addr <= X"0000";
      inputs.cs_n <= '1';
      inputs.rd_n <= '1';      
      inputs.reset_n <= '0';
      inputs.wr_n <= '1';
      wait for 1 us;
      inputs.reset_n <= '1';
      wait for 1 us;

      if run("test_reset") then
        inputs.reset_n <= '0';

        inputs.addr <= X"0000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"4000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"6000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"8000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"A000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"C000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"E000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"4000";
        inputs.rd_n <= '0';
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"A000";
        inputs.cs_n <= '0';
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));

        inputs.addr <= X"4000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '0'));
        inputs.rd_n <= '1';
        inputs.cs_n <= '1';
        wait for 1 us;
        inputs.reset_n <= '1';
        check_outputs((aa => "00", ra => "00001", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
      elsif run("test_reads_after_reset") then
        test_rom_read(inputs, test_addr => X"0000", expected_aa => "00", expected_ra => "00000");
        test_rom_read(inputs, test_addr => X"4000", expected_aa => "00", expected_ra => "00001");
        test_rom_read(inputs, test_addr => X"6000", expected_aa => "00", expected_ra => "00001");
        test_ram_read(inputs, test_addr => X"A000", expected_aa => "00", expected_ra => "00000", expected_ram_cs => '0');
        test_ram_read(inputs, test_addr => X"C000", expected_aa => "00", expected_ra => "00001", expected_ram_cs => '0');
        test_ram_read(inputs, test_addr => X"E000", expected_aa => "00", expected_ra => "00001", expected_ram_cs => '0');
      elsif run("test_ramg") then
        write(inputs, X"0000", X"0A");
        test_ram_read(inputs, test_addr => X"A000", expected_aa => "00", expected_ra => "00000", expected_ram_cs => '1');
        write(inputs, X"0000", X"0F");
        test_ram_read(inputs, test_addr => X"A000", expected_aa => "00", expected_ra => "00000", expected_ram_cs => '0');
        write(inputs, X"0000", X"1A");
        test_ram_read(inputs, test_addr => X"A000", expected_aa => "00", expected_ra => "00000", expected_ram_cs => '1');
        write(inputs, X"0000", X"11");
        test_ram_read(inputs, test_addr => X"A000", expected_aa => "00", expected_ra => "00000", expected_ram_cs => '0');
      elsif run("test_bank1") then
        write(inputs, X"2000", X"1F");
        test_rom_read(inputs, test_addr => X"0000", expected_aa => "00", expected_ra => "00000");
        test_rom_read(inputs, test_addr => X"4000", expected_aa => "00", expected_ra => "11111");
        write(inputs, X"2000", X"00");
        test_rom_read(inputs, test_addr => X"0000", expected_aa => "00", expected_ra => "00000");
        test_rom_read(inputs, test_addr => X"4000", expected_aa => "00", expected_ra => "00001");
        write(inputs, X"2000", X"01");
        test_rom_read(inputs, test_addr => X"0000", expected_aa => "00", expected_ra => "00000");
        test_rom_read(inputs, test_addr => X"4000", expected_aa => "00", expected_ra => "00001");
      elsif run("test_bank2_mode0") then
        write(inputs, X"4000", X"02");
        test_rom_read(inputs, test_addr => X"0000", expected_aa => "00", expected_ra => "00000");
        test_rom_read(inputs, test_addr => X"4000", expected_aa => "10", expected_ra => "00001");
        test_rom_read(inputs, test_addr => X"6000", expected_aa => "10", expected_ra => "00001");
        test_ram_read(inputs, test_addr => X"A000", expected_aa => "00", expected_ra => "00000", expected_ram_cs => '0');
        test_ram_read(inputs, test_addr => X"C000", expected_aa => "10", expected_ra => "00001", expected_ram_cs => '0');
        test_ram_read(inputs, test_addr => X"E000", expected_aa => "10", expected_ra => "00001", expected_ram_cs => '0');
      elsif run("test_bank2_mode1") then
        write(inputs, X"4000", X"02");
        write(inputs, X"6000", X"01");
        test_rom_read(inputs, test_addr => X"0000", expected_aa => "10", expected_ra => "00000");
        test_rom_read(inputs, test_addr => X"4000", expected_aa => "10", expected_ra => "00001");
        test_rom_read(inputs, test_addr => X"6000", expected_aa => "10", expected_ra => "00001");
        test_ram_read(inputs, test_addr => X"A000", expected_aa => "10", expected_ra => "00000", expected_ram_cs => '0');
        test_ram_read(inputs, test_addr => X"C000", expected_aa => "10", expected_ra => "00001", expected_ram_cs => '0');
        test_ram_read(inputs, test_addr => X"E000", expected_aa => "10", expected_ra => "00001", expected_ram_cs => '0');
      elsif run("test_address_switching_write") then
        write(inputs, X"4000", X"01");
        write(inputs, X"6000", X"01");
        inputs.addr <= X"0000";
        inputs.data <= X"AA";
        wait for 1 us;
        inputs.wr_n <= '0';
        wait for 1 us;
        check_outputs((aa => "01", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
        inputs.addr <= X"2000";
        check_outputs((aa => "01", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
        inputs.addr <= X"4000";
        check_outputs((aa => "01", ra => "01010", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
        inputs.addr <= X"6000";
        check_outputs((aa => "10", ra => "01010", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
        inputs.addr <= X"8000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
        inputs.addr <= X"A000";
        check_outputs((aa => "00", ra => "00000", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
        inputs.addr <= X"C000";
        check_outputs((aa => "10", ra => "01010", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
        inputs.addr <= X"E000";
        check_outputs((aa => "10", ra => "01010", ram_cs => '0', ram_cs_n => '1', rom_cs_n => '1'));
      end if;
    end loop;

    wait for 100 ns;
    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, 1 ms);

  uut: entity work.mbc1b
  port map (
    A13 => inputs.addr(13),
    A14 => inputs.addr(14),
    A15 => inputs.addr(15),
    D0 => inputs.data(0),
    D1 => inputs.data(1),
    D2 => inputs.data(2),
    D3 => inputs.data(3),
    D4 => inputs.data(4),
    nCS => inputs.cs_n,
    nRD => inputs.rd_n,
    nRESET => inputs.reset_n,
    nWR => inputs.wr_n,
    AA13 => outputs.aa(13),
    AA14 => outputs.aa(14),
    RA14 => outputs.ra(14),
    RA15 => outputs.ra(15),
    RA16 => outputs.ra(16),
    RA17 => outputs.ra(17),
    RA18 => outputs.ra(18),
    RAM_CS => outputs.ram_cs,
    nRAM_CS => outputs.ram_cs_n,
    nROM_CS => outputs.rom_cs_n
  );
end architecture;
