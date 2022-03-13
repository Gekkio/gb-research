-- SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

entity obuf is
  port(
    I: in std_ulogic;
    OL: out std_ulogic;
    nOH: out std_ulogic);
end entity;

architecture rtl of obuf is
begin
  OL <= not I;
  nOH <= not I;
end architecture;
