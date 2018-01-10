
.. index::
   pair: File format; HIS

HIS
===

Very little information exists on the HIS file format. It seems to have been used by Perkin-Elmer to export X-ray images. Elekta provide it as an image export format. It appears to consist of a 100 byte header (50 16 bit integers) followed by 16 bit integers giving the image data in rows. Integers 9 and 10 appear to give the number of rows and columes respectively.
