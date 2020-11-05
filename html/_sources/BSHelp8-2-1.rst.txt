
.. index:: 
   pair: Image; Invert

Invert
======

Inverts the grey scale values using the formula:

.. math:: NZ = max - Z + min

Where *max* and *min* are the image maximum and minimum respectively. *Z* is the current pixel value and *NZ* is the new pixel value.

|Note| If you don't want an image background level normalise the image first before inverting.

.. |Note| image:: _static/Note.png
