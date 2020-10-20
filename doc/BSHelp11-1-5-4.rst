
.. index:: 
   single: Parameters; ADiff

Point difference base parameter
===============================

The point difference (also called maximum variation) is the maximum absolute difference between the left and right profile values at the same distance from the profile or detector centre:

.. math:: P(dL) - P(dR)
   
for *dR* = -*dL* from the origin as defined by the array or imaging modality to the edge of the in field area.

Variable name: ADiff

|Note| The point difference symmetry may be affected by the field centre. If the field is slightly offset you can use the "Centre field" tool |CentreField| to correct any offset.

.. |Note| image:: _static/Note.png

.. |CentreField| image:: _static/centre.png
