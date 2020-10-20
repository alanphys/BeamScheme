.. index::
   single: Parameters; Inflection point

Inflection Point Parameters
===========================

For FFF beams the standard interpolated or dose level parameters do not give good results. The field edge of FFF beams is defined at the inflection point of the penumbra. For low resolution measuring devices like 2D arrays this can be quite inaccurate. Therefore a sigmoid model is fitted to the penumbra using a Hill function:

.. math:: f(x) = A + \cfrac {B - A} {1 + \left (\cfrac {C} {x} \right)^D}

where:
   * A: sigmoid low level
   * B: sigmoid high level
   * C: approximate inflection point
   * D: slope of the sigmoid
   
The inflection point is determined from:

.. math:: x = C \cdot \left ( \cfrac {D - 1} {D + 1} \right )^{\cfrac {1} {D}}

Once the regression parameters have been determined the inverse Hill function can be used to determine other parameters around the inflection point:

.. math:: x = C \cdot \left ( \cfrac {f(x) - A} {B - f(x)} \right )^{\cfrac {1} {D}}

The profile values to fit are taken from the out field area, that is from 80% of the calculated field size to the end of the profile for fields larger than and including 7x7 cm and are taken from the origin to the end of the profile for fields smaller than 7x7 cm.

|Note| If the penumbra is not well formed the non-linear regression will fail and the results returned will be 0.

.. toctree::
   :maxdepth: 2
   
   BSHelp11-1-3-1.rst
   BSHelp11-1-3-2.rst
   BSHelp11-1-3-3.rst
   BSHelp11-1-3-4.rst
   BSHelp11-1-3-5.rst
   BSHelp11-1-3-6.rst
   BSHelp11-1-3-7.rst
   BSHelp11-1-3-8.rst
   BSHelp11-1-3-9.rst
   BSHelp11-1-3-10.rst
   
.. |Note| image:: _static/Note.png
