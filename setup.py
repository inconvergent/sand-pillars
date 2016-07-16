#!/usr/bin/python3
# -*- coding: utf-8 -*-

try:
  from setuptools import setup
  from setuptools.extension import Extension
except Exception:
  from distutils.core import setup
  from distutils.extension import Extension

from Cython.Build import cythonize
import numpy

_extra = [
    '-O3',
    '-ffast-math'
    ]

req = [
    'cython>=0.24.0'
    ]

extensions = [
    Extension('pillars',
      sources = ['./src/pillars.pyx'],
      extra_compile_args = _extra,
      include_dirs = [numpy.get_include()]
      )
    ]

setup(
    name = "pillars",
    version = '0.0.1',
    author = '@inconvergent',
    install_requires = req,
    zip_safe = True,
    license = 'MIT',
    ext_modules = cythonize(
      extensions
      )
    )

