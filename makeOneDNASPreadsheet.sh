#!/usr/bin/env bash
# Create a canonical form of a DNA_Match_Manager output file

csvformat -T $1 | awk -f getFieldsFromDNA.awk 
