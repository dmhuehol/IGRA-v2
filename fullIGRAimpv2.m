function [v2] = fullIGRAimpv2(filename)
%%fullIGRAimpv2
%   Imports IGRA v2 soundings data into a structure array.
%
%Version date: 5/23/2019
%Last major revision: 5/23/2019
%Written by: Daniel Hueholt
%North Carolina State University
%Undergraduate Research Assistant at Environment Analytics
%

[~,v2] = importIGRAv2(filename); %Make structure and do basic quality control
[v2] = levfilter(v2,3); %Remove level type 3 data
[v2] = addHeight(v2); %Add height
[v2] = addDewRH(v2,'both'); %Add dewpoint and relative humidity (from temperature and dewpoint depression) when possible
[v2] = addDewRH(v2,'dew'); %Add dewpoint (from temperature and relative humidity) when possible

end