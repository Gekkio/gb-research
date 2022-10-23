-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- C²MOS semi-static DFF with Reset
--
-- It is semi-static, because it relies on gate capacitance in one clock phase but
-- is fully static in the other and doesn't require refreshing.
-- The polarity is debatable, and perhaps this should in some cases actually be
-- considered a DFF with Set and the outputs are inverted?
--
-- Variants:
-- 1. PC registers use the full variant
-- 2. IE register uses a slightly different variant with opposite internal
--    reset polarity
-- 3. Control unit uses one yet another variant
entity ssdffr is
  port (
    clk: in std_ulogic;
    en: in std_ulogic;
    d: in std_ulogic;
    res: in std_ulogic;
    q: out std_ulogic;
    nq: out std_ulogic
  );
end entity;

architecture asic of ssdffr is
begin
  process(clk, en, res, d)
    variable storage: std_ulogic;
  begin
    if res then
      storage := '0';
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
