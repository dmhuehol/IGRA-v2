%%dewrelh
    %Function to calculate dewpoint and relative humidity, given
    %inputs of temperature and dewpoint depression in deg C.
    %
    %General form: [dewpoint,relative_humidity] = dewrelh(temp,dpd)
    %
    %Outputs:
    %dewpoint: value or vector of dewpoints (deg C)
    %relative_humidity: value or vector of relative humidity (%)
    %
    %Inputs:
    %temp: value or vector of temperatures. Units must be degrees Celsius!
    %dpd: value or vector of dewpoint depressions. Units must be degrees Celsius!
    %
    %Version date: 4/20/2018
    %Last major revision: 5/31/2017
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %

function [dewpoint,relative_humidity] = dewrelh(temp,dpd)
% Check for missing inputs, and give appropriate warnings
if ~exist('temp','var') && ~exist('dpd','var')
    msg = 'Please input temperature and dewpoint depression!';
    error(msg)
elseif nargin==1
    msg = 'Please input both temperature and dewpoint depression!';
    error(msg)
end

dewpoint = temp - dpd; %Dewpoint is difference of temperature and dewpoint depression

relative_humidity = 100*(exp((17.625*dewpoint)./(243.04+dewpoint))./exp((17.625*temp)./(243.04+temp))); %The August-Roche-Magnus equation, accurate to within 0.4% from -40C to 50C

% Another way to calculate relative humidity, uncomment if you don't want ARM for some reason
%relative_humidity = (100.*(((112 - (0.1.*(temp)) + (dewpoint)) ./ (112 +0.9 .*(temp)))).^8)); %from Martin Wanielista, Robert Kersten & Ron Eaglin, 1997 - Hydrology Water Quantity and Quality Control. John Wiley & Sons - Second edition

end