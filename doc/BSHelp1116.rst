
.. index:: 
   single: Flatness; L80/L50

Flatness L80/L50
================

The 80%/50% isodose ratio is defined as the ratio of the distance to the first point on the profile at 80% of the CAX value to the first point that reaches 50% of the CAX value or field edge. :

.. math:: L80/L50 = maximum \left[\cfrac {dl(P_{80\%})} {dl(P_{50\%})},\cfrac {dr(P_{80\%})} {dr(P_{50\%})} \right ]

.. math:: P_{50\%} = CAX*0.5

.. math:: P_{80\%} = CAX*0.8
   
Where dl(P\ :sub:`50%`) and dl(P\ :sub:`80%`) are the linear distances to the 50% and 80% profile values respectively on the left side of the profile as defined above, and dr(P\ :sub:`50%`) and dr(P\ :sub:`80%`) are the linear distances to the 50% and 80% profile values respectively on the right side of the profile as defined above. The algorithm searches symmetrically out from the profile centre on both sides of the profile to these points. The maximum ratio between the left and right sides is taken.

Since version 0.5 BeamScheme no longer does automatic grounding of the profile, i.e. reducing the minimum to zero. This means that if you want the grounded field size you must *explicitly* normalise or window the image.

|Note| Profiles are no longer grounded automatically. This can lead to differences in results from previous version.

|Note| Noisy data can lead to an inaccurate penumbra value being reported.


.. |Note| image:: _static/Note.png
