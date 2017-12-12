#!/usr/bin/python3

"""
This script checks that one or more JSON files are formatted correctly
according to the following structural requirements:

* The root node should be a dictionary.
* Children should be dictionaries containing only boolean values.
* Successive files should contain the same keys.

In case several files are specified, the files are processed sequentially, and
the former file is used as a basis for checking the structure of the next file.
In case the structure is different, an error message is printed accordingly.

Any error will result in a non-zero exit code.

Example of valid JSON:

    {
        "foo": {
            "abc": true,
            "def": false
        },
        "bar": {},
        "baz": {
            "ghi": false
        }
    }
"""

import argparse
import json
import sys


class ValidationException(Exception):
    pass


class StructuralIntegrityException(Exception):
    pass


def hash_only_type(h, t):
    """
    Assert that `h` is a dictionary containing values only of type `t`.
    """
    assert type(h) == dict
    for k, v in h.items():
        if type(v) != t:
            raise ValidationException("key '%s' should be type '%s', got '%s' instead" % (k, t.__name__, type(v).__name__))

def check_types(tree):
    """
    Assert that `tree` is a dictionary, and that it contains only dictionaries with boolean values.
    """
    hash_only_type(tree, dict)
    try:
        for k, h in tree.items():
            hash_only_type(h, bool)
    except ValidationException as e:
        raise ValidationException("in root node '%s': %s" % (k, str(e)))

def dict_from_json_file(filename):
    """
    Read a JSON structure from a file and return it as a dictionary object.
    """
    with open(filename, 'r') as f:
        jsobject = f.read()
        return json.loads(jsobject)

def compare_structure(a, b):
    """
    Check that two JSON trees have the same key structure.
    """
    if type(a) != type(b):
        raise StructuralIntegrityException('types differ')
    if type(a) == dict:
        if len(a) != len(b):
            raise StructuralIntegrityException('number of elements differ')
        for k in a.keys():
            if k not in b:
                raise StructuralIntegrityException("key '%s' is missing" % k)
            try:
                compare_structure(a[k], b[k])
            except StructuralIntegrityException as e:
                raise StructuralIntegrityException("in '%s': %s" % (k, str(e)))

def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('file', nargs='+')
    args = p.parse_args()

    prev = None
    errors = 0
    for f in args.file:
        try:
            tree = dict_from_json_file(f)
            check_types(tree)
            if prev is not None:
                compare_structure(prev, tree)
            prev = tree
        except StructuralIntegrityException as e:
            print('%s: structure not equal to previous file: %s' % (f, str(e)))
            errors += 1
        except Exception as e:
            print('%s: error: %s' % (f, str(e)))
            errors += 1
        else:
            print('%s: ok' % f)

    return errors


if __name__ == '__main__':
    sys.exit(main())
