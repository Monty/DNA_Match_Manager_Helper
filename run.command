#!/usr/bin/env bash
# Run makeDNASpreadsheet.sh from the Finder

# On macOS, .command files can be executed by double clicking in a Finder window
# or right-clicking and selecting 'Open'. Either will open a Terminal window
# and run them as a shell script.

# Make sure we are in the correct directory
DIRNAME=$(dirname "$0")
cd $DIRNAME

./makeDNASpreadsheet.sh
