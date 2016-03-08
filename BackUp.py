#!/usr/bin/env python
import argparse


def foo(path):
    print('Running foo(%r)' % (path, ))


def bar(path):
    print('Running bar(%r)' % (path, ))

dispatch = {
    'foo': foo,
    'bar': bar,
}

parser = argparse.ArgumentParser()
parser.add_argument('function')
parser.add_argument('arguments', nargs='*')
args = parser.parse_args()

dispatch[args.function](*args.arguments)
~
~
~
~
~
