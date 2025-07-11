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
    from mbc1b_hdl.vunit import configure, create_vhdl_ls_config, testbench_files

    ui = VUnit.from_argv(["--compile"], compile_builtins=False)
    ui.add_vhdl_builtins()
    lib = configure(ui)
    lib.add_source_files(testbench_files)

    with open(root_dir / "vhdl_ls.toml", mode="w") as f:
        create_vhdl_ls_config(ui, f)

    ui.main()


def test(argv):
    from mbc1b_hdl.vunit import configure, testbench_files

    ui = VUnit.from_argv(argv, compile_builtins=False)
    ui.add_vhdl_builtins()
    lib = configure(ui)
    lib.add_source_files(testbench_files)

    ui.main()


def main():
    available_tasks = {
        "clean": clean,
        "compile": compile,
        "test": test
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
