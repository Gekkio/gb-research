-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- C²MOS semi-static DFF
--
-- It is semi-static, because it relies on gate capacitance in one clock phase but
-- is fully static in the other and doesn't require refreshing.
--
-- Variants:
-- 1. Z/W registers use the full variant
-- 2. IR/A/L/H/E/D/C/B registers use a variant that lacks the inverted output
-- 3. SP registers use a variant that seems to be intended for inverted input
-- 4. ALU flag registers use a variant similar to SP, but integrates precharge
--    for the inverted input coming from dynamic logic
-- 5. ALU Z sign register uses a different layout of variant 2
entity ssdff is
  port (
    clk: in std_ulogic;
    en: in std_ulogic;
    d: in std_ulogic;
    q: out std_ulogic;
    nq: out std_ulogic
  );
end entity;

architecture asic of ssdff is
begin
  process(clk, en, d)
    variable storage: std_ulogic;
  begin
    if clk and en then
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
