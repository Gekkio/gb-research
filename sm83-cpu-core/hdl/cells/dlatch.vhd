-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- C²MOS static latch
--
-- Variants:
-- 1. A full-featured one exists in the interrupt section
-- 2. The control unit has a minimal very different one
entity dlatch is
  port (
    clk: in std_ulogic;
    d: in std_ulogic;
    nq: out std_ulogic;
    q: out std_ulogic
  );
end entity;

architecture asic of dlatch is
begin
  process(clk, d)
  begin
    if clk then
      q <= to_ux01(d);
      nq <= not to_ux01(d);
    end if;
  end process;
end architecture;
