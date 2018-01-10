
.. index:: Algorithms

Algorithms
==========

There is an amazing amount of difference in the calculation of supposedly standard parameters between the different vendors. Not only do the definitions of parameters differ but factors such as whether values are interpolated or not or whether field centering is applied have a significant affect on the calculation of the parameters. It is important that the user understand how BeamScheme calculates the various parameters as this will be the first stop in an investigation into any discrepancy between values calculated by BeamScheme and values calculated by vendor supplied software. 

BeamScheme makes absolutely no assumptions about the data in contrast to some commercial products which require parameters such as the field size or SSD to be set. It does not perform any beam centering, and no SSD correction is made. No background correction is assumed. The profile or detector centre is defined as half the profile or detector height or width.

The profile is taken from the windowed data. This can have a serious impact on parameters such as field size and penumbra depending on how the window is chosen. The upshot is that defects in the image such as dead pixels or detectors can be reduced by appropriate windowing.

Calculation of the profiles and parameters are discussed in the following sections.

.. toctree::
   :maxdepth: 1
   
   BSHelp10.rst
   BSHelp11.rst
