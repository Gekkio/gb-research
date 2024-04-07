#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2022 Joonas Javanainen <joonas.javanainen@gmail.com>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

from vunit import VUnit
import toml

source_files = [
    'cells/*.vhd',
    'generated/*.vhd',
    'mbc1b_tb.vhd',
]

ui = VUnit.from_argv(compile_builtins=False)
ui.add_vhdl_builtins()
ui.enable_location_preprocessing()
ui.enable_check_preprocessing()

lib = ui.add_library("mbc1b")
lib.add_source_files(source_files)

def create_vhdl_ls_config(f, source_files):
    libraries = {}
    for file in ui.get_source_files(allow_empty = True):
        files = libraries.setdefault(f'{file.library.name}', {'files': []})
        files['files'].append(file.name)

    libraries['mbc1b'] = {'files': source_files}
    toml.dump({'libraries': libraries}, f)

with open('vhdl_ls.toml', mode='w') as f:
    create_vhdl_ls_config(f, source_files)

ui.main()
