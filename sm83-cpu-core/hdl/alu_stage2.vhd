-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.std_logic_1164.all;
use work.sm83.all;
use work.sm83_alu.all;
use work.sm83_decoder.all;

-- ALU stage 2 (sum/carry/output)
entity alu_stage2 is
  port (
    decoder: in decoder_type;
    inputs: in alu_stage2_in;
    outputs: out alu_stage2_out
  );
end entity;

architecture asic of alu_stage2 is
  signal carry: std_ulogic_vector(8 downto 0);
  signal data_xor: std_ulogic_vector(7 downto 0);
  signal data_sum: std_ulogic_vector(7 downto 0);
  signal result: std_ulogic_vector(7 downto 0);
begin
  carry(0) <= inputs.carry;
  outputs.half_carry <= carry(4);
  outputs.carry <= carry(8);

  carry_gen: for i in 0 to 7 generate
    carry(i + 1) <= inputs.data_generate(i) or (inputs.data_propagate(i) and carry(i));
  end generate;

  -- (A NAND B) AND (A OR B) = A XOR B
  data_xor <= inputs.data_nand and inputs.data_propagate;
  -- A + B + carry
  data_sum <= data_xor xor carry(7 downto 0);

  result <=
    (data_xor and decoder.alu_xor) or
    (data_sum and decoder.alu_sum) or
    inputs.data_logic;

  outputs.data <= result;
  outputs.zero <= '1' when result = x"00" else '0';
end architecture;
