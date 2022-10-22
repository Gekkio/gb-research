# SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

import os
import shutil
from pathlib import Path
from vunit import VUnit

root_dir = Path(__file__).parent.resolve()


def clean():
    vunit_out = root_dir / "vunit_out"
    if vunit_out.exists():
        shutil.rmtree(vunit_out)


def test():
    from sm83_hdl.vunit import configure, create_vhdl_ls_config, testbench_files

    ui = VUnit.from_argv()
    lib = configure(ui)
    lib.add_source_files(testbench_files)

    with open(root_dir / "vhdl_ls.toml", mode="w") as f:
        create_vhdl_ls_config(ui, f)

    ui.main()


def decoder_dump():
    from sm83_hdl.vunit import configure, create_vhdl_ls_config

    ui = VUnit.from_argv()
    lib = configure(ui)
    lib.add_source_file("simulation/decoder_tb.vhd")

    target_path = Path(__file__).parent.resolve() / "decoder.csv"

    def delete_decoder_dump(output_path):
        csv_path = Path(output_path) / "decoder.csv"
        if csv_path.exists():
            csv_path.unlink()
        return True

    def check_decoder_dump(output_path):
        csv_path = Path(output_path) / "decoder.csv"
        if not csv_path.is_file():
            return False
        shutil.copyfile(csv_path, target_path)
        return True

    tb = lib.test_bench("decoder_tb")
    tb.set_generic("dump_csv", "true")
    tb.set_pre_config(delete_decoder_dump)
    tb.set_post_check(check_decoder_dump)

    def post_run(results):
        print(f"Dumped decoder states to {target_path}")

    ui.main(post_run)
