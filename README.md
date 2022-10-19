# IGRA v2
The [Integrated Global Radiosonde Archive version 2](https://www.ncei.noaa.gov/access/metadata/landing-page/bin/iso?id=gov.noaa.ncdc:C00975) is a global archive of quality-controlled radiosonde observations dating back to the early 1900s. This repository contains code to import the data into MATLAB as a consistently-formatted structure array usable by other functions for plotting and analysis. This code has been tested on MATLAB 2017b+.

## General workflow
1. Obtain a data file from the [IGRA v2 archive](https://www1.ncdc.noaa.gov/pub/data/igra/) by saving a file from the `data/data-por/` directory for data over the historical record or `data/data-y2d/` directory for data from the current year only
2. Make a variable `filename` in MATLAB pointing to the location of the data file
3. Run `[v2] = fullIGRAimpv2(filename)` to import the file as a [structure array](https://www.mathworks.com/help/matlab/ref/struct.html)
4. Use `findsnd` to locate a specific date and time

## Step by step example
Let's say that we wanted to look at data from 0Z January 1, 2020 at the Upton, NY site.  
1. Access the [station list file](https://www1.ncdc.noaa.gov/pub/data/igra/igra2-station-list.txt) from the IGRA archive and look up Upton, NY. This file tells us that the Upton station is given by code USM00072501.
2. Go to the [IGRA v2 archive](https://www1.ncdc.noaa.gov/pub/data/igra/data/data-por/) and download the file with the correct station code, in this case, `USM00072501-data.txt.zip`
3. Unzip this file. This will produce a file named `USM00072501-data.txt`
4. Open MATLAB. Make a variable that points to the location of the data file, e.g. `filename = '/Users/[USERNAME]/Downloads/USM00072501-data.txt'`
5. Run `[v2] = fullIGRAimpv2(filename)` to import the Upton data as a [structure array](https://www.mathworks.com/help/matlab/ref/struct.html) named `v2`
6. Run `[numdex] = findsnd(2020,1,1,0,v2)` to locate the index of the data from 0Z January 1 2020. In this case, the index is 18489.
7. Use this index to access the relevant data in the `v2` structure, e.g. `v2(18489)` will print this data to the command window.

## How does this code work?
`fullIGRAimpv2` is a simple wrapper for a bunch of smaller functions: `importIGRAv2`, `levfilter`, `addHeight`, and `addDewRH`.  
      `importIGRAv2` imports and makes a structure from the data, then applies very basic quality control  
      `levfilter` removes WMO level type 3 data (which is out of order from the other data, and throws off other functions)  
      `addHeight` calculates height with a function that uses the Durre and Yin (2008) equation.  
      `addDewRH` calculates dewpoint and relative humidity when enough information is available.  
Help can be obtained for individual functions by using the MATLAB `help name` command, e.g. `help importIGRAv2`

## Sources and credit
Except when specified elsewhere, code and documentation were written by Daniel Hueholt under the advisement of Dr. Sandra Yuter at North Carolina State University.  
[<img src="http://www.environmentanalytics.com/wp-content/uploads/2016/05/cropped-Environment_Analytics_Logo_Draft.png">](http://www.environmentanalytics.com)  

Height calculation comes from Durre, I., & Yin, X. (2008). Enhanced radiosonde data for studies of vertical structure. Bulletin of the American Meteorological Society, 89(9), 1257-1262. Retrieved from [http://www.jstor.org/stable/26220887](http://www.jstor.org/stable/26220887)  

This repository is maintained by [Daniel Hueholt](https://www.hueholt.earth/). Links in this readme file are active as of October 19, 2022.  

Code in this repository is licensed under the GNU General Public License, which is included in the repository as `COPYING.txt`. The full license can be viewed at [gnu.org/licenses/gpl-3.0.en.html](https://www.gnu.org/licenses/gpl-3.0.en.html).
