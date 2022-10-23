-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- C²MOS semi-static DFF with optional Reset/Set
--
-- It is semi-static, because it relies on gate capacitance in one clock phase but
-- is fully static in the other and doesn't require refreshing.
--
-- Variants:
-- 1. Z/W registers: both outputs, no reset/set
-- 2. IR/A/L/H/E/D/C/B registers: no inverted output, no reset/set
-- 3. ALU Z sign register: different layout of variant 2
-- 4. SP register: seems to be intended for inverted input, no reset/set
-- 5. PC register: similar to variant 4, but has set (or reset if input was inverted)
-- 6. IE register: similar to variant 4, but has reset
-- 7. ALU flag registers: similar to variant 4, but different layout and integrates
--    precharge for the inverted input coming from dynamic logic
-- 8. Control unit: yet another variant, no inverted out, has reset
entity ssdff is
  port (
    clk: in std_ulogic;
    en: in std_ulogic;
    res: in std_ulogic := '0';
    set: in std_ulogic := '0';
    d: in std_ulogic;
    q: out std_ulogic;
    nq: out std_ulogic
  );
end entity;

architecture asic of ssdff is
begin
  process(all)
    variable storage: std_ulogic;
  begin
    if res then
      storage := '0';
    elsif set then
      storage := '1';
    elsif clk and en then
      storage := to_ux01(d);
    end if;
    if not clk then
      q <= storage;
      nq <= not storage;
    end if;
  end process;
end architecture;
