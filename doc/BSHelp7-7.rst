
.. index:: 
   pair: File format; XiO

XiO
===

The Elekta XiO or Monaco dose plane export is a text file with a 16 line header followed by dose or fluence values. The file is not associated with any particular extension and is identified by the first line value. If dose values were exported in Gy these are converted into cGy on import. 

|Note| Care should be taken opening XiO files on Windows computers as the CR/LF combination can cause problems.

.. |Note| image:: _static/Note.png
