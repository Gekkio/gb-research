# SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

import os
import psutil
import shutil
import signal
import sys
from pathlib import Path
from vunit import VUnit

current_process = psutil.Process()


def signal_handler(number, frame):
    # Make sure GHDL gets the signal by manually sending it to all descendants
    children = current_process.children(recursive=True)
    for child in children:
        child.send_signal(number)


signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)


root_dir = Path(__file__).parent.resolve()


def clean(argv):
    vunit_out = root_dir / "vunit_out"
    if vunit_out.exists():
        shutil.rmtree(vunit_out)


def compile(argv):
    from sm83_hdl.vunit import configure, create_vhdl_ls_config, testbench_files

    ui = VUnit.from_argv(["--compile"], compile_builtins=False)
    ui.add_vhdl_builtins()
    lib = configure(ui)
    lib.add_source_files(testbench_files)

    with open(root_dir / "vhdl_ls.toml", mode="w") as f:
        create_vhdl_ls_config(ui, f)

    ui.main()


def test(argv):
    from sm83_hdl.vunit import configure

    ui = VUnit.from_argv(argv, compile_builtins=False)
    ui.add_vhdl_builtins()
    lib = configure(ui)
    lib.add_source_files("simulation/decoder_tb.vhd")

    ui.main()


def decoder_dump(argv):
    from sm83_hdl.vunit import configure

    ui = VUnit.from_argv(argv, compile_builtins=False)
    ui.add_vhdl_builtins()
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


def rom(argv):
    from sm83_hdl.vunit import configure

    if len(argv) < 1:
        print("Usage: uv run task.py rom <rom_path>")
        sys.exit(1)

    rom_path = argv[0]

    ui = VUnit.from_argv(argv[1:], compile_builtins=False)
    ui.add_vhdl_builtins()
    lib = configure(ui)
    lib.add_source_file("simulation/test_rom_tb.vhd")
    lib.set_generic("rom_path", rom_path)

    ui.main()


def main():
    available_tasks = {
        "clean": clean,
        "compile": compile,
        "test": test,
        "decoder_dump": decoder_dump,
        "rom": rom
    }
    
    task_name = sys.argv[1] if len(sys.argv) > 1 else None
    if task_name not in available_tasks:
        print("Usage: uv run task.py <task_name>")
        if task_name:
            print(f"Unknown task: {task_name}")
        print(f"Available tasks: {', '.join(available_tasks.keys())}")
        sys.exit(1)
    
    available_tasks[task_name](sys.argv[2:])


if __name__ == "__main__":
    main()

