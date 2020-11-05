
.. index:: 
   pair: File format; iPlan

iPlan
=====

The BrainLab iPlan dose plane export is a text file with a header followed by a separator line followed by one or more dose planes. The dose planes are prefixed by the orientation. The file is identified by the first 8 characters of the first line. If dose values were exported in Gy these are converted into cGy on import. 

|Note| The dose plane orientation is from left to right and may be mirrored from what is displayed on the iPlan depending on the patient orientation.

.. |Note| image:: _static/Note.png
