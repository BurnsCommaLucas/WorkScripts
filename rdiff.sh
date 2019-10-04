#!/bin/ksh

# I to ignore header changes which just clutter the diff when you lock a file

diff -I '\$Header:.*\.' -X /comdsk/burnsl/scripts/exclude.txt -br ./ ./vs | more
