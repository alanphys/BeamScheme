BeamScheme Readme file (c) 2008-2021 AC Chamberlain

1) Introduction
Welcome to BeamScheme

This software will assist you in extracting 1D profiles from 2D datasets and calculating various parameters on the profiles. BeamScheme can open various image and 2D array file formats such as SNC MapCheck, PTW 720, IBA Matrix and StarTrack, XiO, DICOM, jpg, etc.

Parameters such as field size, field centre, penumbra, flatness and symmetry are calculated. Profiles can be taken at any angle, offset or thickness. Profiles can be exported to a text file or clipboard for further processing. Results can be exported to PDF.

BeamScheme is not intended to replace the commercial software available with 2D arrays, but to complement it.

BeamScheme now supports user definable parameters and parameter sets. FFF parameters have been added.

2) Licence
Please read the file Licence.txt. This means that if as a result of using this program you fry your patients, trash your linac, nuke the cat, blow the city power in a ten block radius and generally cause global thermonuclear meltdown! Sorry, you were warned!

3) Installation
It is not necessary to remove previous versions unless these were installed manually.

Run the BSSetup.exe file.

Alternatively extract the files manually and copy into a directory of your choosing.

4) Use
Run the program by double clicking the desktop icon, selecting the "BeamScheme" menu option or double clicking the BeamScheme.exe file in Windows explorer

Open a file by clicking the Open button or selecting "File,Open". If you don't see any files make sure the correct file type is selected.

Use the Offset, Width and Angle boxes to manipulate the profiles.

Windows can be maximised and restored by clicking the arrow in the top right hand corner of the window.

5) Notes on using 2D Array files
For correct field sizes the detector plane of the 2D array must be at 100cm SSD.

There will be small differences between the flatness and symmetry reported by BeamScheme and your 2D Array. This is due to differences in the algorithms. The differences should not be more than 0.05%.

6) Notes on using EPID images
No correction for SSD is made. You will have to apply corrections yourselves at this stage.

It is recommended that an EPID calibration be done before acquiring images to get the best image quality.

If you have an integrated imaging mode, use this as it will give you a better image.

DICOM images will usually need to be inverted (by clicking the Invert button) and then normalised (by clicking the normalise button).

7) Notes on normalising
The program uses the normalised, corrected 2D array data. No normalisation should be necessary for the 2D arrays if they have been calibrated and zeroed correctly.

There are two normalisation modes. CAX or maximum. Normalisation places the minimum of the image at 0 and the CAX or maximum value at 100. If the image contains dead pixels or other strange artifacts it is possible for the normalisation to fail and give you strange results. This is not the fault of the program but of the image. See the previous comment about calibration. Normalisation acts on the windowed data and is non-destructive.

8) Release notes
These detail new or changed functionality in BeamScheme. Please see the History for bug fixes.

Latest release
This is a bug fix release.

Version 0.53
Normalisation is now modal, i.e. non destructive. The normalisation modes are none, norm_cax and norm_max. In mode none the dataset is unnormalised and not grounded with the reference value taken at CAX. For norm_cax the data is grounded and normalised to 100% at the CAX value. For norm_max the data is grounded and normalised to 100% at the profile maximum value. The normalisation modes are enabled by the appropriate toolbar button.

Version 0.52
This version adds support for FFF beams. A Hill function is fitted to the penumbra region to determine the inflection point. Clipboard functionality has been added. Profile and results can be exported to the clipboard. The profiles and results now have context menus giving direct access to this functionality. The online help has been updated.

Version 0.51
BeamScheme now uses Form2PDF to render results to PDF. This has several advantages, the image is printed with the results, considerably less mouse clicks are required to save results and the results are printed as the form itself. The hard copy functionality has been removed. The PDF can, of course, still be printed by any PDF viewer.

Version 0.50
Help has been updated

Parameters are no longer auto normalised. Eg. the field edge or 50% value was calculated on the 50% value between the maximum and minimum of the profile. Now it is calculated on 50% of the maximum of the profile only. The user must explictly normalise the data if the normalised value is required. This is to bring BeamScheme in line with other programs.

Added an expression parser. This allows different parameter sets to be defined. The user can also define parameter sets. Expression editing has been included. Output has been updated to provide for mulitpage output.

Version 0.42
Added new About unit detailing readme, licence and credits.

Version 0.41
Added Average and Standard Deviation parameters over the flattened region of the profiles

Version 0.40
Profiles can now be positioned by clicking on the image with the mouse.

9) Known issues
Windows does not automatically focus the control under the mouse cursor therefore the context sensitive help may return the wrong help page.

With the introduction of FFF parameters and model fitting the linear search algorithm that forms the core of BeamScheme has reached its limitations. The area symmetry used in the FFF protocol uses the field size as defined by the FWHM and not the inflection point due to the limitations of the algorithm.

10) History
22/07/2008 version 0.1
3/09/2009  added DICOM unit
22/8/2011  Fix field centre error,
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
8/1/2018   Add help system
           Fix windowing error on normalise to CAX
25/1/2018  QT5 version must be compiled on Lazarus 1.9 r57132 for correct image display
26/1/2018  Fix panel maximise under QT5
           Fix window level control size under max/min
30/1/2018  Fix area symmetry off by 1
           Fix CAX for even no of detectors
1/2/2018   Add mouse control for profiles
2/2/2018   Fix off by 1 error profile limits
Version 0.4 released 2/2/2018
27/3/2018  Fix regional settings decimal separator
3/4/2018   Add mean and standard deviation
           Fix profile increment
30/4/2019  Fix DTrackbar if image max = maxlongint
3/5/2019   Fix DICOM off by one and pointer conversion
17/7/2019  Update about unit
18/7/2019  Update status bar
23/7/2019  Add expression parser
30/7/2019  Add multipage output
31/7/2019  Fix profile export dirs
1/8/2019   Add expression editor
14/8/2019  Remove auto normalisation of profile values.
           Fix previous image and profile display on open image cancel
11/9/2019  Fix prompt for overwrite results
           Fix protocol list unsorted on reload
           Add Quit Edit menu item
16/9/2019  Fix Y axis swapped for IBA files
10/10/2019 Change BitButtons to SpeedButtons on protocol edit toolbar
           Fix cancel on protocol save
           Fix edit flag on protocol edit exit
           Correct result window title on edit
23/10/2019 Updated help
           Fix click on empty Image pane crash
25/10/2019 Fix user protocol path
Version 0.5 released 25/10/2019
16/4/2020  Fix various memory leaks
6/8/2020   use Form2PDf for printing PDF
           fix SaveDialog titles
           remove results unit and PowerPDF
24/8/2020  add get correct resolution for tiff images
18/9/2020  fix range check error in calcparams
           add inflection points
           neaten filename display
22/9/2020  support raw text file
29/9/2020  shift maths routines to unit mathsfuncs
30/9/2020  shift types and constants to unit bstypes
           use Hill function non linear regression to determine inflection points
           add copy profiles to clipboard
1/10/2020  use parser.SetVariable for performance enhancement
           fix status warning display
           add FFF params inflection point, 0.4*InfP (20%) and 1.6*InfP (80%)
7/10/2020  add copy results to clipboard
           make Protocol read only while not in edit mode
           add context menus for X Y profiles and results
8/10/2020  fix duplicate text file open
           fix RAWOpen range check error
           add sigmoid slope for penumbra
           add position of max
           fix protocol name change on edit
           add profile points for FFF
14/10/2020 add app version
20/10/2020 fix file extensions
5/11/2020  update help
17/11/2020 fix resolution for tiff files
7/12/2020  add normalisation to max for calcs
11/12/2020 make normalisation modal, i.e. non destructive
           change toolbar panel to TToolBar
14/12/2020 select default protocol on startup
3/3/2021   fix FFF penumbra slope
11/9/2021  fix recognise files with tiff extension
4/10/2021  fix ShowProfile and refactor
           fix initialise vars
           profile draw on trackbar change
14/10/2021 Remove sExePath in file Open
22/10/2021 fix profile position on mouse click
