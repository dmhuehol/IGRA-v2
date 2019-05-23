%%dewFromRH
    %Function to calculate dewpoint given temperature and relative
    %humidity. Early soundings only measured relative humidity, not
    %dewpoint depression, and thus dewpoint must be calculated from
    %relative humidity instead of the other way around. Accuracy on this
    %calculation is very good, but note that this does not do anything to
    %change the fact that early humidity measurements from soundings could
    %often be quite inaccurate.
    %
    %General form: [dewpoint] = dewrelh(temp,rhum)
    %
    %Outputs:
    %dewpoint: value or vector of dewpoints (deg C)
    %
    %Inputs:
    %temp: value or vector of temperatures (deg C)
    %rhum: value or vector of humidity (%)
    %
    %Version date: 6/25/2018
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also dewrelh
    %

function [dewpoint] = dewFromRH(temp,rhum)
% Check for missing inputs, and give appropriate warnings

% Coefficients from Alduchov and Eskridge 1996, accurate to relative error
% less than 0.4% over -40 deg C to 50 deg C
a = 17.625; %dimensionless
b = 243.04; %deg C

dewpoint = (b.*(log(rhum./100)+(a.*temp)./(b+temp)))./(a-log(rhum./100)-(a.*temp)./(b+temp));



end