# IGRA v2
The [Integrated Global Radiosonde Archive version 2](https://www.ncdc.noaa.gov/data-access/weather-balloon/integrated-global-radiosonde-archive) is a global archive of quality-controlled radiosonde observations dating back to the early 1900s. This repository contains code to import the data into MATLAB as a consistently-formatted structure array usable by other functions for plotting and analysis. This code has been tested on MATLAB 2017b+.

## General workflow
1. Obtain a data file from the IGRA v2 archive: ftp://ftp.ncdc.noaa.gov/pub/data/igra/data/data-por/
2. Make a variable "filename" in MATLAB pointing to the location of the data file
3. Run [v2] = fullIGRAimpv2(filename)
4. Use findsnd to locate a specific date and time
5. Success!

## How does it work?
fullIGRAimpv2 is a simple wrapper for a bunch of smaller functions: importIGRAv2, levfilter, addHeight, and addDewRH.  
      importIGRAv2 imports and makes a structure from the data, then applies very basic quality control  
      levfilter removes WMO level type 3 data (which is out of order from the other data, and throws off other functions)  
      addHeight calculates height with a function that uses the Durre and Yin (2008) equation.  
      addDewRH calculates dewpoint and relative humidity when enough information is available.  

## Sources and credit
Except when specified elsewhere, code and documentation written by Daniel Hueholt under the advisement of Dr. Sandra Yuter at North Carolina State University.  
[<img src="http://www.environmentanalytics.com/wp-content/uploads/2016/05/cropped-Environment_Analytics_Logo_Draft.png">](http://www.environmentanalytics.com)  

Height calculation comes from Durre, I., & Yin, X. (2008). Enhanced radiosonde data for studies of vertical structure. Bulletin of the American Meteorological Society, 89(9), 1257-1262. Retrieved from [http://www.jstor.org/stable/26220887](http://www.jstor.org/stable/26220887)
