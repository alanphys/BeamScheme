
.. index:: Profiles, diagonal; Profiles, skew

Diagonal/Skew Profiles
======================

Diagonal or skew profiles introduce a number of inaccuracies, which is probably why none of the major vendors offer them. However, if these inaccuracies are understood then skew profiles may yield a lot of useful information. The problem is simple. Consider the following situation.

.. image :: _static/Profile.svg

The squares represent pixels or detectors from a 2D dataset. The red line is an ideal skew profile. If the profile completely bisects a square or detector that value is added to the actual profile (blue square). The problem occurs where the ideal profile partially bisects a square or adjacent squares (green squares). There are a number of possible schemes to solve this such as selecting the nearest pixel or interpolating between adjacent pixels. BeamScheme calculates the length of the profile and then increments an index sequentially along this length. The index is separated into its x and y components which are rounded off to give the pixel indexes along the profile. While the potential does exist for pixels to be skipped or selected twice this is a more robust method and less open to interpretation.

The situation is made worse by the introduction of wide profiles. A wide profile is a profile more than one pixel wide. BeamScheme uses a similar algorithm to that above in that for each index along the profile the normal to the profile is calculated and a second index is sequentially incremented and separated into its x and y components to give the correct pixel. The pixel values are summed. This is done symmetrically on either side of the ideal profile. Thus, the width of the profile will always be odd. This is because an even width will introduce assymmetry in the profile which can lead to further problems.

Skew wide profiles are clipped at the edge of the detector area. This means that the start and finish of wide profiles should be treated with caution and may not be a reflection of reality. The array/image edge will tend to be blurred depending on how skew the profile is.

A similar problem occurs where the profile crosses field edges. If the wide profile is not perpendicular to the field edge this will blur the field edge and increase the penumbra.
