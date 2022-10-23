# SPDX-FileCopyrightText: 2020-2022 Joonas Javanainen <joonas.javanainen@gmail.com>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

from vunit import VUnit
from vunit.ui import Library
from pathlib import Path
import io
import shutil
import toml

source_files = [
    "alu_stage1.vhd",
    "alu_stage2.vhd",
    "alu.vhd",
    "cells/dff.vhd",
    "cells/dlatch.vhd",
    "cells/io_cell.vhd",
    "cells/srlatch.vhd",
    "cells/ssdff_vector.vhd",
    "cells/ssdff.vhd",
    "control_unit.vhd",
    "cpu_core.vhd",
    "decoder_stage1.vhd",
    "decoder_stage2.vhd",
    "decoder_stage3.vhd",
    "decoder.vhd",
    "idu.vhd",
    "interrupts.vhd",
    "regfile.vhd",
    "sm83_alu_pkg.vhd",
    "sm83_decoder_pkg.vhd",
    "sm83_pkg.vhd",
]

testbench_files = [
    "simulation/decoder_tb.vhd",
]


def configure(ui: VUnit) -> Library:
    ui.add_array_util()
    ui.enable_location_preprocessing()
    ui.enable_check_preprocessing()

    lib = ui.add_library("sm83")
    lib.add_source_files(source_files)

    return lib


def create_vhdl_ls_config(ui: VUnit, f: io.IOBase):
    libraries = {}
    for file in ui.get_source_files(allow_empty=True):
        files = libraries.setdefault(f"{file.library.name}", {"files": []})
        files["files"].append(file.name)

    libraries["sm83"] = {"files": source_files}
    toml.dump({"libraries": libraries}, f)
