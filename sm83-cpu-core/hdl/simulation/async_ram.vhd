-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library sm83;
use sm83.sm83_test.all;

entity async_ram is
  generic(
    addr_bits: natural;
    initial_data: mem_type(0 to 2 ** addr_bits - 1) := (others => (others => '0'))
  );
  port(
    bus_ctrl: in soc_bus_ctrl_type;
    cs: in std_ulogic;
    data: inout std_ulogic_vector(7 downto 0)
  );
end entity;

architecture tb of async_ram is
begin
  process(all)
    subtype addr_range is natural range addr_bits - 1 downto 0;

    variable ram: mem_type(0 to 2 ** addr_bits - 1) := initial_data;
  begin
    data <= (others => 'Z');

    if cs then
      if bus_ctrl.rd and not bus_ctrl.wr then
        data <= to_sulv(ram(to_integer(unsigned(bus_ctrl.addr(addr_range)))));
      end if;
      if rising_edge(bus_ctrl.wr) then
        ram(to_integer(unsigned(bus_ctrl.addr(addr_range)))) := to_bv(data);
      end if;
    end if;
  end process;
end architecture;
