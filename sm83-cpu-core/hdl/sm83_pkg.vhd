-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

package sm83 is
  type cpu_flags is record
    carry: std_ulogic;
    half_carry: std_ulogic;
    add_subtract: std_ulogic;
    zero: std_ulogic;
  end record;
end package;
