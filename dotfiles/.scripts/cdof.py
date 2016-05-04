from __future__ import print_function
from contextlib import contextmanager
import glob, sys, os

try:
    from builtins import input
except ImportError:
    pass

# Parse command line arguments
start_dir, file_to_find = sys.argv[1], sys.argv[2]

# Retrieve the results
results = []
for root, directories, filenames in os.walk(start_dir):
    if any([file_to_find in f for f in filenames]):
        results.append(root)

if len(results) == 0:
    print(".") # Return ".", which is the current directory
elif len(results) == 1:
    print(results[0])
else:
    valid = False
    indexed_results = {(i + 1) : r for (i, r) in enumerate(results)}

    while not valid:
        print("Found directories:", file=sys.stderr)
        for i, res in indexed_results.items():
            print("\t%d: %s" % (i, res), file=sys.stderr)
        print("Please select a number: ", file=sys.stderr, end="")
        selection = int(input())

        if selection in indexed_results:
            print(indexed_results[selection])
            valid = True
        else:
            print("Please select a valid result!", file=sys.stderr)
