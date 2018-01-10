
.. index:: 
   single: Field; Edge

Field Edge
==========

The field edges are defined at the first point from the centre of the profile where the profile reaches a value of:

.. math:: \cfrac {max-min} {2} + min

Where *max* is the value of the profile on the central axis (CAX) and *min* is the image or array minimum. If the detector is zeroed to background then *min* = 0 and we get :math:`\cfrac {max} {2}` or the 50% value.

The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. The value reported is the linear distance from the profile centre to the field edge. The left and right field edge of the profile is given.

|Note| Noisy data can lead to a reduced field edge value being reported.

|Note| The *max* and *min* are affected by the set window levels.

.. |Note| image:: _static/Note.png
