# Android System Tools

Support for file formats used in Android system development.

## Features

Syntax highlighting for:

- `Android.bp`

## Installation

### From the Visual Studio Code Marketplace

Just search for it in the marketplace,
or run

    code --install-extension flimberger.android-system-tools

### Building from Source

Currently,
there is no separate build step necessary besides creating the package from the files.
For convenience,
a ``Makefile`` is provided,
which wraps the process into a single command:

    make install

This automatically builds the extension using ``vsce`` and then installs it.
