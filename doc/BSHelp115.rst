
.. index:: 
   single: Penumbra; 80-20%

Penumbra 80%-20%
================

The 80%-20% penumbra is defined as the distance from the first point on the profile at 80% of the CAX value to the first point that reaches 20% of the CAX value:

.. math:: Penumbra(80-20) = abs(d(P_{20\%}) - d(P_{80\%}))

.. math:: P_{20\%} = (max - min)*0.2 + min

.. math:: P_{80\%} = (max - min)*0.8 + min
   
Where d(P\ :sub:`20%`) and d(P\ :sub:`80%`) are the linear distances to the 20% and 80% profile values respectively as defined above. If the detector is zeroed to background then *min* = 0 and we have the 20% and 80% profile values respectively. The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. The left and right field penumbra of the profile is given.

|Note| Noisy data can lead to an inaccurate penumbra value being reported.

|Note| The *max* and *min* are affected by the set window levels.

.. |Note| image:: _static/Note.png
