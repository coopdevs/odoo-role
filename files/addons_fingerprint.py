"""Print a JSON map {addon_name: fingerprint} of the Odoo addons installed with pip.

The fingerprint is built from the file hashes that pip records in each
distribution RECORD file, so it changes whenever the installed code of an
addon changes, even if its version number does not.

It must run with the python interpreter of the Odoo virtualenv.
"""
import csv
import glob
import hashlib
import json
import os
import sys

ADDONS_PREFIX = "odoo/addons/"


def iter_record_files():
    seen = set()
    for path in sys.path:
        if not os.path.isdir(path):
            continue
        for record in glob.glob(os.path.join(path, "*.dist-info", "RECORD")):
            real = os.path.realpath(record)
            if real not in seen:
                seen.add(real)
                yield record


def main():
    entries = {}
    for record in iter_record_files():
        with open(record, newline="") as record_file:
            for row in csv.reader(record_file):
                if len(row) < 2 or not row[1]:
                    continue
                path = row[0].replace(os.sep, "/")
                if not path.startswith(ADDONS_PREFIX):
                    continue
                parts = path[len(ADDONS_PREFIX):].split("/", 1)
                if len(parts) < 2 or not parts[0]:
                    continue
                entries.setdefault(parts[0], []).append(path + ":" + row[1])

    fingerprints = {
        addon: hashlib.sha256("\n".join(sorted(lines)).encode()).hexdigest()
        for addon, lines in entries.items()
    }
    json.dump(fingerprints, sys.stdout, sort_keys=True)


if __name__ == "__main__":
    main()
