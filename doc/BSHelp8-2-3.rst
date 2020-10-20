
.. index:: 
   pair: Image; Normalise to MAX

Normalise to MAX
================

Normalises the image so that the maximum of the image is 100 and the minimum is zero using the formula:

.. math:: NZ = \cfrac {(Z - min)*100} {max - min}

Where *max* and *min* are the image maximum and minimum respectively. *Z* is the current pixel value and *NZ* is the new pixel value.

