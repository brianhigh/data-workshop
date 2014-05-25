#!/bin/sh

# Combine high and low estimates, with high in one file and low in
# another file, skipping first line (header) of each input file.

for i in high low; do \
    # Use tail -n +2 to skip the first line of each file
    tail -q -n +2 EPest.${i}.county.estimates.table*.txt > \
                  EPest.${i}.county.estimates.txt
done
