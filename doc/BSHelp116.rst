
.. index:: 
   single: Penumbra; 90-50%

Penumbra 90%-50%
================

The 90%-50% penumbra is defined as the distance from the first point on the profile at 90% of the CAX value to the first point that reaches 50% of the CAX value or field edge:

.. math:: Penumbra(90-50) = abs(d(P_{50\%}) - d(P_{90\%}))

.. math:: P_{50\%} = (max - min)*0.5 + min

.. math:: P_{90\%} = (max - min)*0.9 + min
   
Where d(P\ :sub:`50%`) and d(P\ :sub:`90%`) are the linear distances to the 50% and 90% profile values respectively as defined above. If the detector is zeroed to background then *min* = 0 and we have the 50% and 90% profile values respectively. The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. The left and right field penumbra of the profile is given.

|Note| Noisy data can lead to an inaccurate penumbra value being reported.

|Note| The *max* and *min* are affected by the set window levels.

.. |Note| image:: _static/Note.png
