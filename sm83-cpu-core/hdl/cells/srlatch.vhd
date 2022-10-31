-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- SR latch with reset priority
entity srlatch is
  port (
    s: in std_ulogic;
    nr: in std_ulogic;
    q: out std_ulogic
  );
end entity;

architecture asic of srlatch is
begin
  process(nr, s)
  begin
    if not nr then
      q <= '0';
    elsif s then
      q <= '1';
    end if;
  end process;
end architecture;
