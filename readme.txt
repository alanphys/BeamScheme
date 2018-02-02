BeamScheme Readme file (c) 2008-2018 AC Chamberlain

1) Licence
Please read the file Licence.txt. This means that if as a result of using this
program you fry your patients, trash your linac, nuke the cat, blow the city
power in a ten block radius and generally cause global thermonuclear meltdown!
Sorry, I did warn you!

2) Installation
It is not necessary to remove previous versions unless these were installed manually.

Run the BSSetup.exe file.

Alternatively extract the files manually and copy into a directory of your
choosing.

3) Use
Run the program by double clicking the desktop icon, selecting the "BeamScheme"
menu option or double clicking the BeamScheme.exe file in Windows explorer

Open a file by clicking the Open button or selecting "File,Open". If you don't
see any files make sure the correct file type is selected.

Use the Offset, Width and Angle boxes to manipulate the profiles.

Windows can be maximised and restored by clicking the arrow in the top right
hand corner of the window.

4) Notes on using 2D Array files
For correct field sizes the detector plane of the 2D array must be at 100cm SSD.

There will be small differences between the flatness and symmetry reported by
BeamScheme and your 2D Array. This is due to differences in the algorithms. The
differences should not be more than 0.05%.

5) Notes on using EPID images
No correction for SSD is made. You will have to apply corrections yourselves at
this stage.

I recommend that an EPID calibration be done before acquiring images to get the
best image quality.

If you have an integrated imaging mode, use this as it will give you a better
image.

DICOM images will usually need to be inverted (by clicking the Invert button)
and then normalised (by clicking the normalise button).

6) Notes on normalising
The program uses the normalised, corrected MapCheck data. No normalisation
should be necessary for the MapCheck if it has been calibrated correctly.

Normalisation places the minimum of the image at 0 and the maximum at 100. If
the image contains dead pixels or other strange artifacts it is possible for the
normalisation to fail and give you strange results. This is not the fault of the
program but of the image. See the previous comment about calibration. Normalisation
now acts on the windowed data.

7) History
22/07/2008 version 0.1
3/09/2009 added DICOM unit
22/8/2011 Fix field centre error,
          Fix Y resolution error for MapCheck 2
28/09/2011 removed MultiDoc
added invert
added normalise
added windowing
fixed profile display
fixed symmetry calculation
cleaned up printout 
Version 0.2 released 1/8/2011
22/8/2011  Fix field centre error,
           Fix Y resolution error for MapCheck 2
15/2/2012  Fix CAX normalisation error,
2/4/2013   Add read for XiO Dose plane file
20/6/2014  Removed redundant DICOM read code causing memory bug
24/6/2014  Fixed XiO read offset by 1
           Fixed MapCheck read if dose cal file not present
           Included Min/Max as part of beam class
           Fixed panel maximise to form area
21/5/2015  combine open dialog and DICOM dialog
20/7/2015  add messaging system
Version 0.3 released 20/7/2015
26/8/2016  Add normalise to max
28/6/2016  Support PTW 729 mcc
29/9/2016  Fix PTW 729 memory error
21/10/2016 Add PowerPDF for output
24/10/2016 Fix Profile event misfire
15/8/2017  Fix image integer conversion
13/10/2017 Support IBA Matrix and StartTrack opg
16/10/2017 Fix Diff divide by zero error
           Fix profile offset limit error
18/11/2017 Fix even number of detectors offset
15/12/2017 Support Brainlab iPlan Dose plane format
           Add text file format identification
8/1/2018   Fix windowing error on normalise to CAX
25/1/2018  QT5 version must be compiled on Lazarus 1.9 r57132 for correct image display
26/1/2018  Fix panel maximise under QT5
           Fix window level control size under max/min
30/1/2018  Fix area symmetry off by 1
           Fix CAX for even no of detectors
1/2/2018   Add mouse control for profiles
2/2/2018   Fix off by 1 error profile limits
