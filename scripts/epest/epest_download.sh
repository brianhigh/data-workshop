#!/bin/sh

# Get the pesticide use text files from the USGS site.

wget --no-parent -e robots=off --recursive --accept=txt \
    --no-directories http://pubs.usgs.gov/ds/752/
