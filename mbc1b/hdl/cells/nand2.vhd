-- SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

entity nand2 is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    y: out std_ulogic);
end entity;

architecture rtl of nand2 is
begin
  y <= not (a and b);
end architecture;
