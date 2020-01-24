function [launchSite] = stationLookupIMPACTS(threeLetterSite)
%%stationLookupIMPACTS
    %Function that decodes the three letter codes for NWS upsonde launches.
    %Written for aircraft flight planning support during NASA IMPACTS 2020
    %deployment.
    %
    %General form: [launchSite] = stationLookupIMPACTS(threeLetterSite)
    %
    %Output
    %launchSite: a string in City, ST format
    %
    %Input
    %threeLetterSite: a three letter code for IMPACTS
    %
    %Version Date: 1/24/2020
    %Last major revision: 1/24/2020
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %
switch threeLetterSite
    case 'ALB'
        launchSite = 'Albany, NY';
    case 'BUF'
        launchSite = 'Buffalo, NY';
    case 'CHH'
        launchSite = 'Chatham, MA';
    case 'CHS'
        launchSite = 'Charleston, SC';
    case 'DTX'
        launchSite = 'White Lake, MI';
    case 'DVN'
        launchSite = 'Davenport, IA';
    case 'GYX'
        launchSite = 'Gray, ME';
    case 'IAD'
        launchSite = 'Sterling, VA';
    case 'ILN'
        launchSite = 'Wilmington, OH';
    case 'ILX'
        launchSite = 'Lincoln, IL';
    case 'MHX'
        launchSite = 'Morehead City, NC';
    case 'MPX'
        launchSite = 'Chanhassen, MN';
    case 'OKX'
        launchSite = 'Upton, NY';
    case 'PIT'
        launchSite = 'Pittsburgh/Moon, PA';
    case 'RNK'
        launchSite = 'Blacksburg, VA';
    case 'WAL'
        launchSite = 'Wallops Island, VA';
    otherwise
        disp('Unknown three letter code!')
        disp(threeLetterSite)
        launchSite = threeLetterSite;
end

end