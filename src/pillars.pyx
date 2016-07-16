# -*- coding: utf-8 -*-
# cython: profile=True

cimport cython

# from libcpp cimport bool # TODO: why does this not work?
# from cpython cimport bool

from libc.math cimport abs

from helpers cimport _random
from helpers cimport _randint
from helpers cimport _max
from helpers cimport _min

import numpy as np
cimport numpy as np


cdef class Pillars:

  def __init__(
      self,
      double[:,:,:] color,
      long[:,:] height,
      int delta,
      double prob,
      int pillar_leap
      ):
    cdef int size = len(initial)
    #
    self.size = size
    self.delta = delta
    self.prob = prob
    self.pillar_leap = pillar_leap
    self.i = 0

    self.pillar = np.zeros((size,size,pillar_leap), 'int')
    self.height[:,:] = height
    self.color[:,:] = color

    self.shadow = np.zeros((size,size), 'int')
    self._init_shadow_map()
    self._init_pillar_map()
    return

  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cdef void _init_pillar_map(self) nogil:
    cdef int i
    cdef int j
    cdef int k
    for i in range(self.size):
      for j in range(self.size):
        for k in range(self.height[i,j]):
          self.pillar[i,j,k] = i*s+j
    return

  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cdef void _init_shadow_map(self) nogil:
    cdef int i
    for i in range(self.size):
      self._shadow_row(i)
    return

  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cdef void _shadow_row(self, const int i) nogil:
    cdef int j
    for j in range(self.size):
      self.shadow[i,j] = 0

    cdef int p = 0
    cdef long h = self.sand[i,p]

    cdef int done = 0
    cdef int long_shadow
    cdef int d
    cdef int pd
    cdef long hd
    while True:
      long_shadow = 1
      for d in range(1,self.delta+1):
        pd = p+d
        hd = self.sand[i,pd%self.size]
        if hd>=h:
          h = hd
          long_shadow = 0
          if pd>=self.size:
            done = 1
          break
        self.shadow[i, pd%self.size] = 1

      p = pd
      if long_shadow==1:
        h = h-1 if h-1>0 else 0
      if p>=self.size and done==1:
        break
    return

  @cython.cdivision(True)
  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cdef int _cascade(self, int i, int j) nogil:
    #TODO: shuffle
    cdef long height = self.sand[i,j]
    cdef int* directions = [
        i,(j-1)%self.size,
        i,(j+1)%self.size,
        (i-1)%self.size,j,
        (i+1)%self.size,j
        ]

    cdef int d
    cdef int a
    cdef int b
    cdef long df
    for d in range(4):
      a = directions[2*d]
      b = directions[2*d+1]
      df = height-self.sand[a,b]
      if df<-2:
        self.sand[a,b] -= 1
        self.sand[i,j] += 1
        return b
      elif df>2:
        self.sand[a,b] += 1
        self.sand[i,j] -= 1
        return b
    return -1

  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cdef void _erode(self, const long i, const long j, const long diff) nogil:
    self.sand[i,j] += diff
    cdef int r = self._cascade(i, j)
    if r>-1 and r!=i:
      self._shadow_row(r)
    self._shadow_row(i)

  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cdef void _random_select(self, int* ij) nogil:
    cdef int i
    cdef int j
    while True:
      i = _randint(self.size)
      j = _randint(self.size)
      if self.sand[i,j]<1:
        continue
      if self.shadow[i,j]>0:
        continue
      ij[0] = i
      ij[1] = j
      return

  @cython.cdivision(True)
  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cpdef void get_normalized_sand(self, double[:,:] out):
    cdef int i
    cdef int j
    cdef long ma = self.sand[0,0]
    cdef long mi = self.sand[0,0]
    cdef double nrm = 0.0

    with nogil:
      for i in range(self.size):
        for j in range(self.size):
          ma = _max(ma, self.sand[i,j])
          mi = _min(mi, self.sand[i,j])

      nrm = <double>(ma-mi)
      for i in range(self.size):
        for j in range(self.size):
          out[i,j] = <double>(self.sand[i,j]-mi)/nrm
    return

  @cython.cdivision(True)
  @cython.wraparound(False)
  @cython.boundscheck(False)
  @cython.nonecheck(False)
  cpdef void get_shadow(self, double[:,:] out):
    cdef int i
    cdef int j

    with nogil:
      for i in range(self.size):
        for j in range(self.size):
          out[i,j] = <double>(self.shadow[i,j])
  #
  cpdef int steps(self, int steps):
    cdef int *ij = [0, 0]
    cdef int i
    cdef int j
    cdef int k
    for k in range(steps):
      self.i += 1
      self._random_select(ij)
      i = ij[0]
      j = ij[1]

      self._erode(i, j, -1)
      while True:
        j = (j+1)%self.size
        if self.shadow[i,j] or _random()<self.prob:
          self._erode(i, j, 1)
          break
    return self.i

