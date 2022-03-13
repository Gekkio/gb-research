-- SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

entity odrv is
  port(
    PIN: out std_ulogic;
    nOH: in std_ulogic;
    OL: in std_ulogic);
end entity;

architecture rtl of odrv is
begin
  process(nOH, OL)
  begin
    if nOH = '0' and OL = '1' then
      PIN <= 'X';
    elsif nOH = '1' and OL = '1' then
      PIN <= '0';
    elsif nOH = '0' and OL = '0' then
      PIN <= '1';
    else
      PIN <= 'Z';
    end if;
  end process;
end architecture;
