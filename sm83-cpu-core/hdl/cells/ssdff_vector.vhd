-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;

-- C²MOS semi-static DFF with optional Reset/Set (multi-bit version for model simplicity)
--
-- See ssdff for more details
entity ssdff_vector is
  generic (WIDTH: natural);
  port (
    clk: in std_ulogic;
    en: in std_ulogic;
    res: in std_ulogic := '0';
    set: in std_ulogic := '0';
    d: in std_ulogic_vector(WIDTH-1 downto 0);
    q: out std_ulogic_vector(WIDTH-1 downto 0);
    nq: out std_ulogic_vector(WIDTH-1 downto 0)
  );
end entity;

architecture asic of ssdff_vector is
begin
  process(all)
    variable storage: std_ulogic_vector(WIDTH-1 downto 0);
  begin
    if res then
      storage := (others => '0');
    elsif set then
      storage := (others => '1');
    elsif clk and en then
      storage := to_ux01(d);
    end if;
    if not clk then
      q <= storage;
      nq <= not storage;
    end if;
  end process;
end architecture;
