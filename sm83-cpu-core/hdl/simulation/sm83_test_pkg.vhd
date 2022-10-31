-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
use vunit_lib.integer_array_pkg.all;

package sm83_test is
  type clocks_type is record
    clk: std_ulogic;
    phi: std_ulogic;
    mclk_pulse: std_ulogic;
    writeback: std_ulogic;
    writeback_ext: std_ulogic;
  end record;

  type soc_bus_ctrl_type is record
    wr: std_ulogic;
    rd: std_ulogic;
    addr: std_ulogic_vector(15 downto 0);
  end record;

  type mem_type is array (natural range <>) of bit_vector(7 downto 0);

  impure function read_array(a: integer_array_t; addr: std_ulogic_vector) return std_ulogic_vector;

  function to_ascii(data: std_ulogic_vector(7 downto 0)) return character;
end package;

package body sm83_test is
  impure function read_array(a: integer_array_t; addr: std_ulogic_vector) return std_ulogic_vector is
    variable array_addr: integer;
    variable array_data: integer;
  begin
    array_addr := to_integer(unsigned(addr));
    array_data := get(a, array_addr);
    return std_ulogic_vector(to_unsigned(array_data, 8));
  end function;

  function to_ascii(data: std_ulogic_vector(7 downto 0)) return character is
  begin
    return character'val(to_integer(unsigned(data)));
  end function;
end package body;
