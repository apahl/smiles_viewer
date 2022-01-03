# Build with:
# nimble buildDebug    # to build debug version in main directory
# nimble buildRelease  # for release build in `bin/` directory

# Run with:
# LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$RDKIT_CONDA/lib smiles_viewer  # (on Linux)

# Package

version       = "0.2.0"
author        = "Axel Pahl"
description   = "A SMILES structure viewer"
license       = "MIT"
srcDir        = "src"
bin           = @["smiles_viewer"]
backend       = "cpp"

# Dependencies

requires "nim >= 1.6.2"
requires "rdkit >= 0.1"
requires "https://github.com/marcomq/webview >= 0.1"

import os

task buildDebug, "build debug version in main directory":
  # Hack: `webview` is defined so that `rdkit` includes an additional link directory for the correct GTK libs.
  let buildCmd = "nim -o:./smiles_viewer -d:webview cpp src/smiles_viewer.nim"
  exec buildCmd

task buildRelease, "build release version (bin/smiles_viewer)":
  mkdir("bin")
  # Hack: `webview` is defined so that `rdkit` includes an additional link directory for the correct GTK libs.
  let buildCmd = "nim -o:bin/smiles_viewer -d:webview -d:release cpp src/smiles_viewer.nim"
  exec buildCmd
