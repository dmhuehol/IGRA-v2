%%addHeight
    %Adds geopotential height field to a sounding data structure. Uses
    %equation found in Durre and Yin (2008).
    %Link to paper: http://journals.ametsoc.org/doi/pdf/10.1175/2008BAMS2603.1
    %
    %General form: [geoSound] = addHeight(soundStruct)
    %
    %Output
    %geosound: sounding structure with calculated geopotential height field,
    %otherwise identical to input structure
    %
    %Input:
    %soundStruct: processed soundings data structure, as from IGRAimpf
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version Date: 4/9/2019
    %Last major revision: 6/25/2018
    %
    %See also IGRAimpf, prestogeo
    %

function [geoSound] = addHeight(soundStruct)
geoSound = soundStruct;
errorCount = 1;
errorThreshold = 0.08*length(soundStruct); %Set a threshold for an acceptable number of errors

for count = 1:length(soundStruct)
    try
        [~,geoSound(count).calculated_height] = prestogeo(soundStruct(count).pressure,soundStruct(count).temp); %prestogeo converts pressure to geopotential height
    catch ME %#ok, it just hates the fact that ME doesn't go anywhere
        errorCount = errorCount+1;
        if errorCount>errorThreshold %This keeps the function from blundering through a forest of errors; don't change this without a REALLY good reason
            msg = 'Number of errors has exceeded standard value!';
            disp(msg);
            prompt = 'Continue? Y/N '; %Don't want to end the function entirely, as some soundings will legitimately have more than 8% error 
            %(common for historical soundings datasets, particularly outside the US or pre-1990)
            str = input(prompt,'s');
            if strcmp(str,'N')==1
                stopMsg = 'Stopped!';
                error(stopMsg)
            end
            if strcmp(str,'Y')==1
                msg = 'Continued processing';
                disp(msg)
                errorCount = 0; errorThreshold = length(soundStruct)+1;
                continue
            end
        else
            continue
        end
    end
end

%disp(errorCount); %Uncomment this line for troubleshooting
end