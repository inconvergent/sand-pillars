# -*- coding: utf-8 -*-

def get_colors(f, do_shuffle=True):
  from numpy import array
  try:
    import Image
  except Exception:
    from PIL import Image

  im = Image.open(f)
  data = array(list(im.convert('RGB').getdata()),'float')/255.0

  res = []
  for rgb in data:
    res.append(list(rgb))

  if do_shuffle:
    from numpy.random import shuffle
    shuffle(res)
  return res

def get_img_as_rgb_array(f):
  from PIL import Image
  from numpy import array
  from numpy import reshape
  im = Image.open(f)
  w,h = im.size
  data = array(list(im.convert('RGB').getdata()), 'float')/255.0
  return reshape(data,(w,h,3))

def get_initial_rnd(size, n=15):
  from scipy.ndimage.filters import gaussian_filter
  from numpy.random import random
  initial = random((size,size))*n
  gaussian_filter(
    initial,
    2,
    output=initial,
    order=0,
    mode='mirror'
    )
  return initial.astype('int')

def get_initial(img, n=15):
  from modules.helpers import get_img_as_rgb_array
  initial = get_img_as_rgb_array(img)[:,:,0].squeeze()
  initial *= n
  return initial.astype('int')

def save_shadow_map(size, dunes, sand, fn='shadow.png'):
  from numpy import zeros
  from numpy import dstack

  bw = zeros((size,size),'float')
  shadow = zeros((size,size),'float')
  dunes.get_normalized_sand(bw)
  dunes.get_shadow(shadow)
  rgb = dstack((zeros(bw.shape,'float'),bw,1.0-shadow))
  sand.set_bg_from_rgb_array(rgb)
  sand.write_to_png(fn)

