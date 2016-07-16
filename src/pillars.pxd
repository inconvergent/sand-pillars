# -*- coding: utf-8 -*-
# cython: profile=True

cimport cython


cdef class Pillars:

  cdef int size
  cdef int delta
  cdef double prob
  cdef int pillar_leap
  cdef int i

  cdef long[:,:,:] pillar
  cdef double[:,:,:] color
  cdef long[:,:] height

  cdef long[:,:] shadow

  cdef void _init_pillar_map(self) nogil
  cdef void _init_shadow_map(self) nogil
  cdef void _shadow_row(self, const int i) nogil
  cdef void _random_select(self, int* ij) nogil
  cdef void _erode(self, const long, const long, const long) nogil
  cdef int _cascade(self, int i, int j) nogil

  cpdef void get_normalized_sand(self, double[:,:])
  cpdef void get_shadow(self, double[:,:])

  cpdef int steps(self, int steps)

