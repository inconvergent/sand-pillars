#!/usr/bin/python3
# -*- coding: utf-8 -*-

from numpy import zeros


SIZE = 1000
IMG = './img/gen.png'
ONE = 1./SIZE

LEAP = 50000
PROB = 0.3

DELTA = 10
PILLAR_LEAP = 1000

BACK = [1,1,1,1]
FRONT = [0,0,0,5]



def main():

  from pillars import Pillars
  from sand import Sand
  from fn import Fn
  from time import time


  from modules.helpers import get_img_as_rgb_array
  color = get_img_as_rgb_array(IMG)
  height = zeros(color.shape,'int')
  height[:,:] = 10
  bw = zeros(color.shape,'float')

  dunes = Pillars(color, height, DELTA, PROB, PILLAR_LEAP)

  sand = Sand(SIZE)
  sand.set_rgba(FRONT)
  fn = Fn(prefix='./res/', postfix='.png')

  # try:
  #   while True:
  #     t0 = time()
  #     itt = dunes.steps(LEAP)
  #     print(itt, time()-t0)
  #     dunes.get_normalized_sand(bw)
  #     # bw *= 0.8
  #     # sand.set_bg_from_bw_array(bw)
  #     # dunes.get_shadow(shadow)
  #     # rgb = dstack((bw,bw,shadow))
  #     # sand.set_bg_from_rgb_array(rgb)
  #     sand.set_bg_from_bw_array(bw)
  #     name = fn.name()
  #     sand.write_to_png(name)
  #
  # except KeyboardInterrupt:
  #   pass


if __name__ == '__main__':
  main()

