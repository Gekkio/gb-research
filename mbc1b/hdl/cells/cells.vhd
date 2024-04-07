-- SPDX-FileCopyrightText: 2022-2024 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0
library ieee;
use ieee.std_logic_1164.all;

package cells is

  component aoi22 is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    c: in std_ulogic;
    d: in std_ulogic;
    ny: out std_ulogic);
  end component;

  component dffr is
  port(
    CLK: in std_ulogic;
    nRESET: in std_ulogic;
    nD: in std_ulogic;
    Q: out std_ulogic := '0';
    nQ: out std_ulogic := '1');
  end component;

  component inv is
  port(
    a: in std_ulogic;
    y: out std_ulogic);
  end component;

  component nand2 is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    y: out std_ulogic);
  end component;

  component nand2_pwr is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    y: out std_ulogic);
  end component;

  component nand4 is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    c: in std_ulogic;
    d: in std_ulogic;
    y: out std_ulogic);
  end component;

  component nand5 is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    c: in std_ulogic;
    d: in std_ulogic;
    e: in std_ulogic;
    y: out std_ulogic);
  end component;

  component nor2_pwr is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    y: out std_ulogic);
  end component;

  component oai21 is
  port(
    a: in std_ulogic;
    b: in std_ulogic;
    c: in std_ulogic;
    ny: out std_ulogic);
  end component;

  component obuf is
  port(
    I: in std_ulogic;
    OL: out std_ulogic;
    nOH: out std_ulogic);
  end component;

  component odrv is
  port(
    PIN: out std_ulogic;
    nOH: in std_ulogic;
    OL: in std_ulogic);
  end component;

  component schmitt is
  port(
    a: in std_ulogic;
    y: out std_ulogic);
  end component;

end package;
