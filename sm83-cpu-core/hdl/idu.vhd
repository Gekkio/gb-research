-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sm83_decoder.all;

-- Increment/Decrement Unit (IDU)
entity idu is
  port (
    phi: in std_ulogic;
    decoder: in decoder_type;
    carry: in std_ulogic;
    z_sign: in std_ulogic;
    data_in: in std_ulogic_vector(15 downto 0);
    data_out: out std_ulogic_vector(15 downto 0)
  );
end entity;

architecture asic of idu is
  signal jr_pos_carry, jr_neg_carry, jr_carry: std_ulogic;
  signal inc, dec: std_ulogic;
begin
  jr_pos_carry <= decoder.op_jr_any_sx01 and carry and not z_sign;
  jr_neg_carry <= decoder.op_jr_any_sx01 and not carry and z_sign;
  jr_carry <= jr_pos_carry or jr_neg_carry;
  inc <= jr_pos_carry or decoder.idu_inc;
  dec <= jr_neg_carry or decoder.idu_dec;

  process(all)
    variable propagate: std_ulogic_vector(15 downto 0);
    variable carry_out: std_ulogic_vector(15 downto 0);
  begin
    carry_out := (others => '0');
    carry_out(0) := (inc or dec);
    if not phi then
      propagate := (data_in and inc) or (not data_in and dec);
      carry_out(1) := propagate(0);
      carry_out(2) := propagate(1) and carry_out(1);
      carry_out(3) := propagate(2) and carry_out(2);
      carry_out(4) := propagate(3) and carry_out(3);
      carry_out(5) := propagate(4) and carry_out(4);
      carry_out(6) := propagate(5) and carry_out(5);
      carry_out(7) := propagate(6) and carry_out(6);
      carry_out(8) := (propagate(7) and carry_out(7)) or jr_carry;
      carry_out(9) := propagate(8) and carry_out(8);
      carry_out(10) := propagate(9) and carry_out(9);
      carry_out(11) := propagate(10) and carry_out(10);
      carry_out(12) := propagate(11) and carry_out(11);
      carry_out(13) := propagate(12) and carry_out(12);
      carry_out(14) := propagate(13) and carry_out(13);
      carry_out(15) := propagate(14) and carry_out(14);
    end if;

    data_out <= data_in xor carry_out;
  end process;
end architecture;
