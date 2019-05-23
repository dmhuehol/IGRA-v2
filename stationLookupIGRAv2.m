function [name] = stationLookupIGRAv2(stationID)
%%stationLookupIGRAv2
%Retrieves the station name for a sounding launch site. Requires
%the "IGRA v2 Station List.mat" file to be present in the active directory.
%
%General form: [name] = stationLookupIGRAv2(stationID)
%
%Output:
%name: Name of the sounding launch site in Proper Case
%
%Input:
%stationID: the 11-character IGRA v2 station identifier
%
%Version date: 8/14/2018
%Last major revision: 6/27/2018
%Written by: Daniel Hueholt
%North Carolina State University
%Undergraduate Research Assistant at Environment Analytics
%
%See also importIGRAv2
%


load('IGRA v2 Station List.mat') %Must be in active directory

% Extract name
[~,nameIndex,~] = intersect(igra2stationlist.Identifier,stationID);
rawName = cell2mat(igra2stationlist.Name(nameIndex));

% For some sites, the name in the station list is not a great
% representation and needs to be improved by hand
% For most, make the name capitalized case for better readability
switch nameIndex
    case 2161
        name = 'Denver/Stapleton Airport';
        return
    case 2173
        name = 'LaGuardia Airport';
        return
    case 2256
        name = 'JFK Airport';
        return
    otherwise
        rawName = lower(rawName);
        rawName = strtrim(rawName); %Remove all preceding and trailing whitespace
        upperInd(1) = 1; %First letter will always need capitalization
        otherInd = regexp(rawName,'(?<=\s+)\S'); %Finds all other characters preceded by whitespace
        upperInd = [upperInd otherInd];
        rawName(upperInd) = upper(rawName(upperInd));
        name = rawName;     
end
        
end