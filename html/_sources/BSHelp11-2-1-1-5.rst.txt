
.. index:: 
   single: Penumbra; 80-20%

Penumbra 80%-20%
================

The 80%-20% penumbra is defined as the distance from the first point on the profile at 80% of the CAX value to the first point that reaches 20% of the CAX value:

.. math:: Penumbra(80-20) = abs(d(P_{20\%}) - d(P_{80\%}))

.. math:: P_{20\%} = CAX*0.2

.. math:: P_{80\%} = CAX*0.8
   
Where d(P\ :sub:`20%`) and d(P\ :sub:`80%`) are the linear distances to the 20% and 80% profile values respectively as defined above. The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. The left and right field penumbra of the profile is given.

Since version 0.5 BeamScheme no longer does automatic grounding of the profile, i.e. reducing the minimum to zero. This means that if you want the grounded field size you must *explicitly* normalise or window the image.

|Note| Profiles are no longer grounded automatically. This can lead to differences in results from previous version.

|Note| Noisy data can lead to an inaccurate penumbra value being reported.

.. |Note| image:: _static/Note.png
