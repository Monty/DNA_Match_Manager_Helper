#!/usr/bin/env bash
# Create a canonical form of a DNA_Match_Manager output file

# head -10 $1 | csvformat -T | awk -f getFieldsFromDNA.awk 
csvformat -T $1 | awk -f getFieldsFromDNA.awk 
