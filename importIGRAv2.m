%%importIGRAv2
    %Imports IGRA v2 sounding data files into a MATLAB data structure,
    %where each field is an individual sounding.
    %
    %General form: [v1sndng,v2sndng] = importIGRAv2(filename)
    %
    %Outputs:
    %v1sndng: A soundings data structure that is completely identical to
    %   the soundings structures of IGRA v1, and is thus compatible with
    %   all software written to work with IGRA v1.
    %   The following fields exist in v1sndng:
    %   valid_date_num: a MATLAB date vector
    %   year
    %   month
    %   day
    %   hour: the nominal/observation hour, usually 0 or 12 but rarely 6 or 18
    %   level_type: major level type (1 = standard level, 2 = additional, 3 = wind)
    %   minor_level_type: 1 = surface, 2 = tropopause, 3 = other
    %   pressure: measured in Pascals
    %   geopotential: measured in meters
    %   temp: dry-bulb air temperature, measured in deg C
    %   dew_point_dep: dewpoint depression, measured in deg C
    %   wind_dir: wind direction, measured in angular degrees from north, such that 90 represents due east
    %   wind_spd: wind speed, measured in meters/second
    %   u_comp: zonal component of wind, measured in meters/second
    %   v_comp: meridional component of wind, measured in meters/second
    %   geopotential_flag: 1 = value is within climatological limits based on all years and all days at the station, 2 = value is within climatological limits and limits based on specifics to the time of year and time of day at the station, 0 = no climatological check
    %   pressure_flag: same meaning as geopotential flag
    %   temp_flag: same meaning as geopotential flag
    %
    %v2sndng: Contains all of the data fields found in v1sndng, as well as
    %   the following fields which are only available in IGRA v2 data.
    %   release_time: the actual UTC HHMM time of release
    %   elapsed_time: the time taken by the balloon to reach the current level in MMMSS
    %   rhum: measured in %
    %   latitude: measured in decimal but recorded without decimal point
    %   longitude: measured in decimal but recorded without decimal point
    %   
    %Input:
    %filename: A file name and path for an IGRA v2 data txt file.
    %
    %Version date: 6/28/2018
    %Last major revision: 6/14/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %

function [v1sndng,v2sndng] = importIGRAv2(filename)

%% Import the raw data
dataForLength = fileread(filename); %Read file as a character block
count = length(dataForLength(dataForLength == 35)); %Finds number of soundings by finding all instances of #, which denotes a header and is found at the beginning of all soundings
dataForLength = []; %Blank the data block

header = cell(count,1); %Preallocate header array
raw = cell(1,count); %Preallocate raw data array

fid = fopen(filename); %Open input file

for r = 1:count %Loop to count
    header{r} = textscan(fid,'#%3c%8c%4f%2f%2f%2f%4f%4f%8c%8c%7f%8f', 1);

%Example: #USM00072501 1994 09 03 00 2314  166 ncdc6301 ncdc6301  408656  -728647
% #%#%3c%8f%4f%2f%2f%2f%4f%4f%8c%8c%7f%8f
%   # - start header NOTE: this character is not imported
%1:  %3c - identifier: country code+station network code (2+1 = 3 characters)
%2:   %8c - station ID (8 characters) NOTE: imported as characters because some stations have letters in their ID
%3:   %4f - year (4 digits)
%4:   %2f - month (2 digits)
%5:   %2f - day (2 digits)
%6:   %2f - hour (2 digits)
%7:   %4f - release time (4 digits)
%8:   %4f - number of levels (4 digits)
%9:   %8c - pressure level source (8 characters)
%10:   %8c - other level source (8 characters)
%11:   %7f - latitude (7 digits, reported without decimal)
%12:   %8f - longitude (8 digits, reported without decimal)

%   Input 1 at end of textscan call is number of times to read the header

    raw{r} = textscan(fid, '%51c', header{r}{8});
%   Identifies data raw as a block of characters
    
%   header{r}{8} uses the LEVEL NUMBER designator from the
%      IGRA file to determine how many times to run this second textscan call
%      rather than the first (header) textscan call
end

%% Create a soundings structure in the IGRA v1 style
v1sndng = struct([]); %Preallocation cuts down on runtime very slightly

for r = 1:count
    recordDate = [header{r}{3} header{r}{4} header{r}{5} header{r}{6}]; %year, month, date, UTC nominal/observation hour
    v1sndng(r).valid_date_num = datenum(recordDate); %Convert date to serial number
    
    % These fields are already doubles because of the format string in the
    % header textscan call
    v1sndng(r).year = recordDate(1);
    v1sndng(r).month = recordDate(2);
    v1sndng(r).day = recordDate(3);
    v1sndng(r).hour = recordDate(4);
    
    % Convert level types to numbers
    %   sscanf is the fastest way to convert from string to number, but
    %   only works when the length of the string is completely consistent
    v1sndng(r).level_type = sscanf(raw{r}{1}(:,1),'%1f');
    v1sndng(r).minor_level_type = sscanf(raw{r}{1}(:,2),'%1f');
    
    % Convert pressure string to number, and separate the flags
    v1sndng(r).pressure = str2num(raw{r}{1}(:,10:15)); %#ok
    press_flag = double(raw{r}{1}(:,16));
    
    % Convert geopotential string to number, and separate the flags
    v1sndng(r).geopotential = str2num(raw{r}{1}(:,17:21)); %#ok %Must be str2num; str2double and sscanf both fail
    geopot_flag = double(raw{r}{1}(:,22));
    
    % Convert air temperature to number, and separate the flags
    v1sndng(r).temp = str2num(raw{r}{1}(:,23:27))/10; %#ok
    temp_flag = double(raw{r}{1}(:,28));
    
    % Convert dewpoint depression to number, and separate the flags
    v1sndng(r).dew_point_dep = str2num(raw{r}{1}(:,35:39))/10; %#ok
    
    % Convert wind speed to numbers, and NaN the values flagged by IGRA quality control
    v1sndng(r).wind_dir = str2num(raw{r}{1}(:,41:45)); %#ok
    v1sndng(r).wind_spd = str2num(raw{r}{1}(:,47:51))/10; %#ok
    v1sndng(r).wind_dir(v1sndng(r).wind_dir<-900) = NaN; %This step is taken here instead of with other QC steps so that u/v can be calculated without issue
    v1sndng(r).wind_spd(v1sndng(r).wind_spd<-900) = NaN;
    
    % Calculate the u and v components of the wind
    v1sndng(r).u_comp = -v1sndng(r).wind_spd .* cos(-v1sndng(r).wind_dir - 90);
    v1sndng(r).v_comp = -v1sndng(r).wind_spd .* sin(-v1sndng(r).wind_dir - 90);
    
    % Collect the flags and convert them to a more accessible format
    flags = [press_flag geopot_flag temp_flag];
    flags(flags==32) = 0;
    flags(flags==65) = 1;
    flags(flags==66) = 2;
    v1sndng(r).geopotential_flag = int8(flags(:,1));
    v1sndng(r).pressure_flag = int8(flags(:,2));
    v1sndng(r).temp_flag = int8(flags(:,3));
    
    % NaN the values flagged by IGRA quality control
    v1sndng(r).pressure(v1sndng(r).pressure < 0) = NaN;
    v1sndng(r).geopotential(v1sndng(r).geopotential < 0) = NaN;
    v1sndng(r).temp(v1sndng(r).temp< -888) = NaN;
    v1sndng(r).dew_point_dep(v1sndng(r).dew_point_dep< -888) = NaN; 
end

%% Construct the v2 structure
v2sndng = v1sndng; %v1 and v2 structures share most of their fields

for r = 1:count
    % Convert release time and elapsed time to number
    v2sndng(r).release_time = header{r}{7}; %Actual launch time of the sounding in HHMM UTC time
    v2sndng(r).elapsed_time = str2num(raw{r}{1}(:,4:8)); %#ok %Elapsed time in MMMSS without leading zeros
    v2sndng(r).rhum = str2num(raw{r}{1}(:,29:33))/10; %#ok %Relative humidity
    
    v2sndng(r).rhum(v2sndng(r).rhum<0) = NaN; %Convert impossible humidity values to NaN
    
    % Collect the latitude/longitude and convert them to numbers
    %   Note that nothing is done here about the lack of decimals
    if isnan(header{r}{12})==1 %Sometimes the non-pressure level source code will be missing; in this case the latitude/longitude fields are fields 10 and 11, respectively
        v2sndng(r).latitude = header{r}{10};
        v2sndng(r).longitude = header{r}{11};
    else %If the non-pressure level source code is reported (as it is in most cases), then the latitude/longitude fields are 11 and 12, as expected
        v2sndng(r).latitude = header{r}{11};
        v2sndng(r).longitude = header{r}{12};
    end
    
    v2sndng(r).stationID = [header{r}{1} header{r}{2}]; % Station ID
end

end