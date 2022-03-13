-- SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

entity dffr is
  port(
    CLK: in std_ulogic;
    nRESET: in std_ulogic;
    nD: in std_ulogic;
    Q: out std_ulogic := '0';
    nQ: out std_ulogic := '1');
end entity;

architecture rtl of dffr is
begin
  process(CLK, nRESET)
  begin
    if nRESET = '0' then
      Q <= '0';
      nQ <= '1';
    elsif rising_edge(clk) then
      nQ <= nD;
      Q <= not nD;
    end if;
  end process;
end architecture;
