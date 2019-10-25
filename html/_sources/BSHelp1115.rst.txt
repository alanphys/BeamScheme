
.. index:: 
   single: Deviation; Maximum Variation

Maximum Variation
=================

This is the maximum variation in the ration of the absorbed dose at any point in the flattened area to that of the central axis expressed as a percentage difference between the lowest and highest value of this ratio.

.. math:: 100 \cdot \cfrac {max - min} {cax}

Practically though this has been implemented as:

.. math:: 100 \cdot maximum \left[\cfrac {max - cax} {cax}, \cfrac {min-cax} {cax} \right ]
   
Where *max*, *min* and *cax* are the profile maximum, minimum and central axis values respectively.

|Note| The *max*, *min* and *cax* are affected by the set window levels.

.. |Note| image:: _static/Note.png
