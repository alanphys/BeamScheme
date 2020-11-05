.. index::
   pair: Algorithms; In field area
   
In field area
=============

The in field area (IFA) refers to the flattened area of WFF beams. A number of varying definitions exist depending on the protocol. Practically these are very difficult to implement as they are usually only defined for certain profile angles and field sizes. An additional problem is that the IFA is defined on the nominal field width which may be widely different from the actual field width.

To avoid these problem BeamScheme simply takes the in field area as 80% of the FWHM. This corresponds to most definitions for standard fields such as 10x10 and 20x20, but may overestimate the in field area for small fields (< 5cm) and underestimate the in field area for large fields (> 30cm).

The field statistics, flatness and symmetry values are all calculated from the in field area. For any discrepancies between values calculated by BeamScheme and other software first examine the defined in field area.
