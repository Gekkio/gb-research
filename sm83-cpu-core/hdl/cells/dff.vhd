-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- C²MOS static DFF
entity dff is
  port (
    clk: in std_ulogic;
    d: in std_ulogic;
    q: out std_ulogic
  );
end entity;

architecture asic of dff is
begin
  process(clk, d)
    variable storage: std_ulogic;
  begin
    if clk then
      q <= storage;
    elsif not clk then
      storage := to_ux01(d);
    end if;
  end process;
end architecture;
