-- SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

entity schmitt is
  port(
    a: in std_ulogic;
    y: out std_ulogic);
end entity;

architecture rtl of schmitt is
begin
  y <= a;
end architecture;
