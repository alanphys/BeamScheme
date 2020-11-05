
.. index:: 
   pair: Image; Normalise to CAX

Normalise to CAX
================

Normalises the image so that the central axis (CAX) value of the image is 100 and the minimum is zero using the formula:

.. math:: NZ = \cfrac {(Z - min)*100} {cax - min}

Where *cax* and *min* are the image central axis value and minimum respectively. *Z* is the current pixel value and *NZ* is the new pixel value.
