-- SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
--
-- SPDX-License-Identifier: MIT OR Apache-2.0

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use std.textio.all;

library vunit_lib;
context vunit_lib.vunit_context;

library sm83;
use sm83.sm83_decoder.all;

entity decoder_tb is
  generic(
    runner_cfg: string;
    dump_csv: boolean := false
  );
end entity;

architecture tb of decoder_tb is
  signal clk: std_ulogic := '0';
  signal phi: std_ulogic := '1';

  type inputs_type is record
    writeback: std_ulogic;
    intr_dispatch: std_ulogic;
    cb_mode: std_ulogic;
    data_lsb: std_ulogic;
    ir_reg: std_ulogic_vector(7 downto 0);
    state: std_ulogic_vector(2 downto 0);
  end record;

  signal inputs: inputs_type := (
    ir_reg => X"00",
    state => "000",
    others => '0'
  );

  signal stage1: decoder_stage1_type;
  signal stage2: decoder_stage2_type;
  signal stage3: decoder_stage3_type;
  signal outputs: decoder_type;

  signal dump_enable: bit := '1';
  signal dump_trigger: bit := '0';
begin
  main: process
    procedure dump_csv_row is
    begin
      dump_trigger <= '1';
      wait for 1 ns;
      dump_trigger <= '0';
      wait for 1 ns;
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);

    for intr_dispatch in std_ulogic range '0' to '1' loop
      inputs.intr_dispatch <= intr_dispatch;
      for cb_mode in std_ulogic range '0' to '1' loop
        inputs.cb_mode <= cb_mode;
        for ir_reg in 0 to 255 loop
          inputs.ir_reg <= std_ulogic_vector(to_unsigned(ir_reg, 8));
          for state in 0 to 7 loop
            inputs.state <= std_ulogic_vector(to_unsigned(state, 3));
            for data_lsb in std_ulogic range '0' to '1' loop
              inputs.data_lsb <= data_lsb;
              for writeback in std_ulogic range '0' to '1' loop
                inputs.writeback <= writeback;

                phi <= '0';
                clk <= '1';
                wait for 1 ns;

                check_not_unknown(to_stdulogicvector(stage1), result("for unknown check, stage 1"));
                check_not_unknown(to_stdulogicvector(stage2), result("for unknown check, stage 2"));
                check_not_unknown(to_stdulogicvector(stage3), result("for unknown check, stage 3"));
                check_not_unknown(to_stdulogicvector(outputs), result("for unknown check"));

                dump_csv_row;

                clk <= '0';
                phi <= '1';
                wait for 1 ns;

                check_equal(or to_stdulogicvector(stage1), '0', result("for CLK=0,PHI=1 check stage 1"));
                check_equal(or to_stdulogicvector(stage2), '0', result("for CLK=0,PHI=1 check stage 2"));
                check_equal(or to_stdulogicvector(stage3), '0', result("for CLK=0,PHI=1 check stage 3"));
                check_equal(or to_stdulogicvector(outputs), '0', result("for CLK=0,PHI=1 check"));
              end loop;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;

    dump_enable <= '0';
    wait for 1 ns;

    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, 10 ms);

  stage1_inst: entity sm83.decoder_stage1
  port map (
    clk => clk,
    intr_dispatch => inputs.intr_dispatch,
    cb_mode => inputs.cb_mode,
    ir_reg => inputs.ir_reg,
    state => inputs.state,
    outputs => stage1
  );

  stage2_inst: entity sm83.decoder_stage2
  port map (
    clk => clk,
    stage1 => stage1,
    outputs => stage2
  );

  stage3_inst: entity sm83.decoder_stage3
  port map (
    clk => clk,
    phi => phi,
    writeback => inputs.writeback,
    cb_mode => inputs.cb_mode,
    ir_reg => inputs.ir_reg,
    data_lsb => inputs.data_lsb,
    stage1 => stage1,
    stage2 => stage2,
    outputs => stage3
  );

  process(all)
  begin
    outputs <= to_decoder_type(stage1, stage2, stage3);
  end process;

  dump_csv_gen: if dump_csv generate
    process
      constant FILE_NAME: string := output_path(runner_cfg) & "decoder.csv";

      file output_file: text open write_mode is FILE_NAME;

      procedure print_csv_header is
        variable output_line: line;
      begin
        write(output_line, string'("intr_dispatch,cb_mode,ir_reg,state,writeback,data_lsb,stage1,stage2,stage3,outputs"));
        writeline(output_file, output_line);
      end procedure;

      procedure dump_csv_row is
        variable output_line: line;
      begin
        write(output_line, inputs.intr_dispatch);
        write(output_line, string'(","));
        write(output_line, inputs.cb_mode);
        write(output_line, string'(",0x"));
        hwrite(output_line, inputs.ir_reg);
        write(output_line, string'(","));
        write(output_line, inputs.state);
        write(output_line, string'(","));
        write(output_line, inputs.writeback);
        write(output_line, string'(","));
        write(output_line, inputs.data_lsb);
        write(output_line, string'(","));
        write(output_line, to_stdulogicvector(stage1));
        write(output_line, string'(","));
        write(output_line, to_stdulogicvector(stage2));
        write(output_line, string'(","));
        write(output_line, to_stdulogicvector(stage3));
        write(output_line, string'(","));
        write(output_line, to_stdulogicvector(outputs));
        writeline(output_file, output_line);
      end procedure;
    begin
      print_csv_header;

      while dump_enable loop
        wait until rising_edge(dump_trigger);
        dump_csv_row;
        wait until dump_trigger = '0';
      end loop;
      info("Dumped raw decoder states to " & FILE_NAME);

      loop
        wait;
      end loop;
    end process;
  end generate;
end architecture;
