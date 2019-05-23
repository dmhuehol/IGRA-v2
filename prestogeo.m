function [presheightvector,geoheightvector] = prestogeo(pressure,temperature,replacefirst,soundstructure,soundingnumber,talk)
%%prestogeo
    %Function to calculate geopotential height given pressure and
    %temperature, with options to replace the first height with measured data.
    %Technically, prestogeo actually calculates the geopotential thickness of a layer,
    %but is calculating the layer from the surface to the given level, whose thickness
    %is the geopotential height of the given pressure level tz. prestogeo was
    %designed for use within other functions and scripts, and thus includes a
    %few otherwise largely extraneous settings making it easier to use for that
    %purpose. If you are looking for a more basic geopotential height calculator,
    %see simple_prestogeo.
    %
    %General form: [presheightvector,geoheightvector] = prestogeo(pressure,temperature,replacefirst,soundstructure,soundingnumber)
    %
    %Outputs:
    %presheightvector: vector of pressures converted from input of Pa to output of hPa (mb).
    %geoheightvector: vector of calculated geopotential heights (with first replaced as requested based on 
    %   value of replacefirst, see below) in kilometers.
    %
    %Inputs:
    %pressure: vector of pressure data in Pa (conversion to hPa is built-in)
    %temperature: vector of temperature data in deg C (conversion to K is built-in)
    %replacefirst: controls whether the first value in geoheight vector is replaced with 
    %   measured value or not. The first value is always calculated to be 0km, so the first measured value 
    %   (when present) is more accurate, especially for plotting purposes.
    %   1 to enable, 0 to disable.
    %soundstructure: sounding structure which provides the first geopotential height value for replacefirst. 
    %    DO NOT ENTER unless looking to use the replacefirst functionality.
    %soundingnumber: number of requested sounding, provided so that the proper measured first value can be
    %    found within the sounding structure. DO NOT ENTER unless looking to use the replacefirst functionality.
    %talk: logical value which controls whether prestogeo reports the progress of geopotential height calculations
    %    in the command window. 1 for verbose, 0 for quiet.
    %
    %Note: a switch statement is used to ensure that prestogeo will complete even with input variables missing. 
    %   replacefirst, soundstructure, soundingnumber, and talk can be left off of any calls to prestogeo without 
    %   impairing the function at all. The only inputs which are essential are pressure and temperature.
    %
    %Version Date: 6/5/2018
    %Last major revision: 5/31/17
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also simple_prestogeo
    %

% Run in quiet mode by default.
if ~exist('talk','var')
    talk = 0;
end
    
try %Keeps the function from causing hiccups when used in a long loop scenario, where a few irregular instances might cause problems
    presheightvector = pressure/100; %convert Pa to hPa (mb)
    R = 287.75; %J/(K*kg) ideal gas constant
    grav = 9.81; %m/s^2 acceleration of gravity
    for z = 1:length(presheightvector') %Calculate a geopotential height vector of corresponding length to the pressure level vector
        geoheightvector(z) = (R/grav*(((temperature(1)+273.15)+(temperature(z)+273.15))/2).*log(presheightvector(1)./presheightvector(z)))/1000; %Equation comes from Durre and Yin (2008) http://journals.ametsoc.org/doi/pdf/10.1175/2008BAMS2603.1
    end
    geoheightvector = geoheightvector'; %Make row vector into a column vector
    
    % All of the following has to do with the more convoluted uses of input variables
    % and can be ignored if all you are looking for is a geopotential height calculator
    switch nargin %Different cases occur with different number of input variables, easier than if/elseif
        case 6 %If all inputs are present
            if replacefirst == 1 %If first calculated value is to be replaced with measured value (calculated value is always zero, so the measurement is more accurate)
                if isnan(soundstructure(soundingnumber).geopotential(1))==0
                    geoheightvector(1) = soundstructure(soundingnumber).geopotential(1)/1000; %Change the first geopotential height to the first measured geopotential height
                    if talk == 1
                        disp('First calculation replaced with first measurement.')
                    else
                    end
                elseif isnan(soundstructure(soundingnumber).geopotential(1))==1 && isnan(soundstructure(soundingnumber).geopotential(2))==0
                    geoheightvector(1) = soundstructure(soundingnumber).geopotential(2)/1000; %Change first geopotential height to first measured height (second entry in structure)
                    if talk == 1
                        disp('First calculation replaced with second measurement.')
                        disp(soundingnumber)
                    else
                    end
                elseif isnan(soundstructure(soundingnumber).geopotential(1))==1 && isnan(soundstructure(soundingnumber).geopotential(2))==1 && isnan(soundstructure(soundingnumber).geopotential(3))==0
                    geoheightvector(1) = soundstructure(soundingnumber).geopotential(3)/1000; %Change first geopotential height to first measured height (third entry in structure)
                    if talk == 1
                        disp('First calculation replaced with third measurement.')
                        disp(soundingnumber)
                    else
                    end
                else
                    if talk == 1
                        disp('First three geopotential height entries were all missing; calculated value of zero was left alone.')
                        disp(soundingnumber)
                    else
                    end
                end
            elseif replacefirst == 0 %If first calculated value is to be left alone
                if talk == 1
                    disp('Geopotential heights left at calculated values.');
                end
            end
        case 5 %If talk is missing
            if replacefirst == 1 %If first calculated value is to be replaced with measured value (calculated value is always zero, so the measurement is more accurate)
                if isnan(soundstructure(soundingnumber).geopotential(1))==0
                    geoheightvector(1) = soundstructure(soundingnumber).geopotential(1)/1000; %change the first geopotential height to the first measured geopotential height
                elseif isnan(soundstructure(soundingnumber).geopotential(1))==1 && isnan(soundstructure(soundingnumber).geopotential(2))==0
                    geoheightvector(1) = soundstructure(soundingnumber).geopotential(2)/1000; %change first geopotential height to first measured height (second entry in structure)
                elseif isnan(soundstructure(soundingnumber).geopotential(1))==1 && isnan(soundstructure(soundingnumber).geopotential(2))==1 && isnan(soundstructure(soundingnumber).geopotential(3))==0
                    geoheightvector(1) = soundstructure(soundingnumber).geopotential(3)/1000; %change first geopotential height to first measured height (third entry in structure)
                else
                end
            elseif replacefirst == 0 %If first calculated value is to be left alone
                disp('Geopotential heights left at calculated values.')
            end
        case 4 %If sounding number is missing
            disp('Need sounding number in order to replace first entry with measured reading.')
            return
        case 3 %Soundings structure isn't present
            disp('Need soundings data in order to replace first entry with measured reading.')
            return
        case 2 %No input regarding replacefirst
            if talk == 1
                disp('First values have been left at zero.')
            end
            return
        case 1 %If the input is REALLY off target
            disp('Invalid input! Check help for more information on form.')
        otherwise
            disp('Invalid input! Check syntax.')
    end
catch ME;
end
end
