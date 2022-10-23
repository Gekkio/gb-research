-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- "I/O cell" between SoC data bus and the CPU
entity io_cell is
  port (
    clk: in std_ulogic;
    alu_data: in std_ulogic;
    alu_data_oe: in std_ulogic;
    test_t1: in std_ulogic;
    ext_data: inout std_ulogic;
    int_data: inout std_ulogic
  );
end entity;

architecture asic of io_cell is
  signal int_data_resolved: std_logic;
  signal ext_data_resolved: std_logic;
begin
  int_data_resolved <= '0' when not alu_data and alu_data_oe else 'Z';
  int_data <= int_data_resolved;

  ext_data <= 'Z' when test_t1 else ext_data_resolved;

  ext_to_int: process (all)
  begin
    if clk and not test_t1 then
      if ext_data'event then
        int_data_resolved <= ext_data after 1 ns;
      end if;
    else
      int_data_resolved <= 'Z';
    end if;
  end process;

  int_to_ext: process (all)
  begin
    if clk then
      if int_data'event then
        ext_data_resolved <= int_data after 1 ns;
      end if;
    else
      ext_data_resolved <= 'Z';
    end if;
  end process;

  ext_data_resolved <= '1' when not clk else 'H';
  int_data_resolved <= '1' when not clk else 'H';
end architecture;
