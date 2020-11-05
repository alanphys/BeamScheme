
.. index:: 
   single: Field; Edge

Field Edge
==========

The field edges are defined at the first point from the centre of the profile where the profile reaches the 50% value, i.e.:

.. math:: \cfrac {CAX} {2}

Where *CAX* is the value of the profile on the central axis (CAX).

Since version 0.5 BeamScheme no longer does automatic grounding of the profile, i.e. reducing the minimum to zero. This means that if you want the grounded field size you must *explicitly* normalise or window the image.

The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. If the 50% value lies between measured points the field edge is interpolated. The value reported is the linear distance from the profile centre to the field edge. The left and right field edge of the profile is given.

|Note| Profiles are no longer grounded automatically. This can lead to differences in results from previous version.

|Note| Noisy data can lead to a reduced field edge value being reported.


.. |Note| image:: _static/Note.png
