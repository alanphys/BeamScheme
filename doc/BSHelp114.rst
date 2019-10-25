
.. index:: 
   single: Penumbra; 90-10%

Penumbra 90%-10%
================

The 90%-10% penumbra is defined as the distance from the first point on the profile at 90% of the CAX value to the first point that reaches 10% of the CAX value:

.. math:: Penumbra(90-10) = abs(d(P_{10\%}) - d(P_{90\%}))

.. math:: P_{10\%} = CAX*0.1

.. math:: P_{90\%} = CAX*0.9
   
Where d(P\ :sub:`10%`) and d(P\ :sub:`90%`) are the linear distances to the 10% and 90% profile values respectively as defined above. The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. The left and right field penumbra of the profile is given. 

Since version 0.5 BeamScheme no longer does automatic grounding of the profile, i.e. reducing the minimum to zero. This means that if you want the grounded field size you must *explicitly* normalise or window the image.

|Note| Profiles are no longer grounded automatically. This can lead to differences in results from previous version.

|Note| Noisy data can lead to an inaccurate penumbra value being reported.

.. |Note| image:: _static/Note.png
