-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- C²MOS semi-static DFF with Set
--
-- It is semi-static, because it relies on gate capacitance in one clock phase but
-- is fully static in the other and doesn't require refreshing.
entity ssdffs is
  port (
    clk: in std_ulogic;
    en: in std_ulogic;
    d: in std_ulogic;
    set: in std_ulogic;
    q: out std_ulogic;
    nq: out std_ulogic
  );
end entity;

architecture asic of ssdffs is
begin
  process(clk, en, set, d)
    variable storage: std_ulogic;
  begin
    if set then
      storage := '1';
    elsif clk and en then
      case d is
        when '1' | 'H' => storage := '1';
        when '0' | 'L' => storage := '0';
        when others => storage := 'X';
      end case;
    end if;
    if not clk then
      q <= storage;
      nq <= not storage;
    end if;
  end process;
end architecture;
