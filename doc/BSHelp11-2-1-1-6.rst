
.. index:: 
   single: Penumbra; 90-50%

Penumbra 90%-50%
================

The 90%-50% penumbra is defined as the distance from the first point on the profile at 90% of the CAX value to the first point that reaches 50% of the CAX value or field edge:

.. math:: Penumbra(90-50) = abs(d(P_{50\%}) - d(P_{90\%}))

.. math:: P_{50\%} = CAX*0.5

.. math:: P_{90\%} = CAX*0.9
   
Where d(P\ :sub:`50%`) and d(P\ :sub:`90%`) are the linear distances to the 50% and 90% profile values respectively as defined above. The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. The left and right field penumbra of the profile is given.

Since version 0.5 BeamScheme no longer does automatic grounding of the profile, i.e. reducing the minimum to zero. This means that if you want the grounded field size you must *explicitly* normalise or window the image.

|Note| Profiles are no longer grounded automatically. This can lead to differences in results from previous version.

|Note| Noisy data can lead to an inaccurate penumbra value being reported.


.. |Note| image:: _static/Note.png
