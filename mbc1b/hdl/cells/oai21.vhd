-- SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

entity oai21 is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    c: in std_ulogic;
    ny: out std_ulogic);
end entity;

architecture rtl of oai21 is
begin
  ny <= not (a and (b or c));
end architecture;
