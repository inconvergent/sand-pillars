# -*- coding: utf-8 -*-

cimport cython

from libc.stdlib cimport rand
cdef extern from "limits.h":
  int INT_MAX

@cython.wraparound(False)
@cython.boundscheck(False)
@cython.nonecheck(False)
cdef inline double _random() nogil:
  return <double>rand()/<double>INT_MAX

@cython.wraparound(False)
@cython.boundscheck(False)
@cython.nonecheck(False)
cdef inline int _randint(int a) nogil:
  return rand()%a

@cython.wraparound(False)
@cython.boundscheck(False)
@cython.nonecheck(False)
cdef inline long _min(long a, long b) nogil:
  if a<b:
    return a
  return b

@cython.wraparound(False)
@cython.boundscheck(False)
@cython.nonecheck(False)
cdef inline long _max(long a, long b) nogil:
  if a>b:
    return a
  return b
