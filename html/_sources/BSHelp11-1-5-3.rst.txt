
.. index:: 
   single: Parameters; RDiff

Maximum dose ratio base parameter
=================================

The maximum dose ratio symmetry (also called the point difference quotient) is the maximum ratio between the left and right profile values at the same distance from the profile or detector centre:

.. math:: maximum \left [\cfrac {P(dL)} {P(dR)} , \cfrac {P(dR)} {P(dL)} \right ]
   
for *dR* = -*dL* from the origin as defined by the array or imaging modality to the end of the in field area.

Variable name: RDiff

|Note| The ratio symmetry is affected by the field centre. If the field is slightly offset you can use the "Centre field" tool |CentreField| to correct any offset.

.. |Note| image:: _static/Note.png

.. |CentreField| image:: _static/centre.png
