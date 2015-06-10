import os
import re
import argparse

# Build the argument parser
parser = argparse.ArgumentParser(description = "Removes unnecessary files from a directory")

parser.add_argument("--recursive", "-r", action = "store_true",
        help = "sub-directories will also be traversed")
parser.add_argument("dir", action = "store", nargs = "?", default = os.getcwd(),
        help = "the directory to start removing files in")
parser.add_argument("--verbose", "-v", action = "store_true",
        help = "program will make note of each removal and directory traversed")

# Build the regular expression to match file names to delete
extensions = ["un~", "swp"]
extensions_regex = r'.*\.(%s)$' % "|".join(extensions)
regex = re.compile(extensions_regex)

def parse_directory(directory, recursive = False, debug = False):
    if debug:
        print("Parsing directory \"%s\"" % directory)

    removal_count = 0

    files_in_dir = os.listdir(directory)
    subdirs = []

    # Sort through the directory, handle the files, and store the directories
    for f in files_in_dir:
        filename = "%s/%s" % (directory, f)

        if os.path.isfile(filename):
            removal_count += parse_file(filename)
        else:
            subdirs.append(f)

    # Handle subdirectories if the recursive flag has been enabled
    if recursive:
        for subdir in subdirs:
            removal_count += parse_directory("%s/%s" % (directory, subdir), recursive, debug)

    return removal_count

def parse_file(filename, debug = False):
    if regex.match(filename):
        if debug:
            print("Removing file: %s" % filename)

        os.remove(filename)
        return 1
    return 0

def main():
    args = parser.parse_args()
    removal_count = parse_directory(args.dir, recursive = args.recursive, debug = args.verbose)

    message = "Removed %d %s." % (removal_count, "files" if removal_count != 1 else "file")
    print( message )

if __name__ == "__main__":
    main()
