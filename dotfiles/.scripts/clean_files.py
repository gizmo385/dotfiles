import os.path, os
import re
import sys
import shlex
from math import fabs

# Get the system arguments
args = sys.argv
calling_dir = args[1]
removal_count = 0

files = [f for f in os.listdir(calling_dir) if os.path.isfile(f)]

# This regular expression matches strings that end in a un~ or swp extension.
p = re.compile(r'.*\.(un~|swp)')


# Remove files whose names match the regular expression
for file in files:
    if p.match(file):
        removal_count += 1
        os.remove(file)

message = "Removed " + str(removal_count) + " "
message += "files." if fabs(removal_count) != 1 else "file."

print( message )
