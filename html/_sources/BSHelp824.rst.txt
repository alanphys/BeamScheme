
.. index:: 
   pair: Image; Centre field

Centre Field
============

Shifts the image by the value of the X and Y field centres. The pixel value at the new index is determined using bi-linear interpolation from the four nearest neighbour pixels from the original image. Image wrap around is not used. Pixels on the leading edge of the image are lost and pixels on the trailing edge are duplicated. This function is intended for fine field adjustments only.

|Note| This function changes the original image data.

.. |Note| image:: _static/Note.png


