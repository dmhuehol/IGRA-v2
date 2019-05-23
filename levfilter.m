%%levfilter
    %Function to remove levels from a structure of soundings data,
    %such as that created by IGRAimpf. Given a sounding structure and a level
    %type, levfilter will remove all data from the structure which corresponds
    %to said level.
    %
    %General form: [fil] = levfilter(sounding,level_type)
    %
    %Output:
    %fil: a structure lacking the data of level_type,
    %
    %Inputs:
    %sounding: a structure of soundings data,
    %level_type: a number (0,1,2,3) corresponding to WMO standard level types.
    %
    %Usually used to remove additional wind level data (data that only
    %includes height and wind data) - in this case level_type equals 3.
    %
    %Written by Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version Date: 6/25/2018
    %Last major revision: 6/13/2017
    %
    %See also IGRAimpf, fullIGRAimp
    %
    
function [fil] = levfilter(sounding,level_type)

fil = sounding; %Structure to be targeted
r = length(fil); %Find number of soundings
for t = 1:r %Loop through structure
    [index] = find(fil(t).level_type==level_type); %Find indices of wind level
    %Destroy all data corresponding to the given indices
    %Must be done one at a time because accessing multiple variables across
    %nested structures is not a vectorizable process (as far as I can tell)
    fil(t).level_type(index) = [];
    fil(t).minor_level_type(index) = [];
    fil(t).pressure(index) = [];
    fil(t).geopotential(index) = [];
    fil(t).temp(index) = [];
    fil(t).dew_point_dep(index) = [];
    fil(t).wind_dir(index) = [];
    fil(t).wind_spd(index) = [];
    fil(t).u_comp(index) = [];
    fil(t).v_comp(index) = [];
    fil(t).geopotential_flag(index) = [];
    fil(t).pressure_flag(index) = [];
    fil(t).temp_flag(index) = [];
    if isfield(fil,'dewpt')==1
        fil(t).dewpt(index) = [];
    end
    if isfield(fil,'rhum')==1
        fil(t).rhum(index) = [];
    end
end
end
