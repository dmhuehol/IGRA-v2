%%TTwvZ_kft
    %Function to plot the height profile in km and kFt of temperature and
    %wetbulb temperature. Written for aircraft flight planning support
    %during NASA IMPACTS 2020 deployment.
    %
    %General form: [f] = TTwvZ_kft(sounding,kmTop)
    %
    %Output
    %f: the figure handle
    %
    %Inputs
    %sounding: a TABLE of soundings data as imported from U Wyo files
    %kmTop: OPTIONAL INPUT maximum km to plot. Defaults to 13km.
    %
    %Version Date: 1/24/2020
    %Last major revision: 1/24/2020
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also wetbulb, importImpacts, stationLookupIMPACTS
    %

function [f] = TTwvZ_kft(sounding,kmTop)
if ~exist('kmTop','var')
    disp('Maximum height set to default value.');
    kmTop = 10;
end

launchSite = stationLookupIMPACTS(sounding.Properties.CustomProperties.launch_site);
disp(['Date: ' datestr(sounding.Properties.CustomProperties.valid_date_num)])
disp(['Three letter site: ' sounding.Properties.CustomProperties.launch_site])
disp(['Decoded site: ' launchSite]) 
disp(['Maximum height: ' num2str(kmTop)])

%% Confine all data to between surface and maximum requested height
useHeight = sounding.height;
useHeight = useHeight./1000;
kmCutoff = logical(useHeight <= kmTop+1); %Find indices of readings where the height less than the maximum height requested, plus a bit for better plotting
useTemp = sounding.temp(kmCutoff==1);
useHeight = useHeight(kmCutoff==1);

%% Calculate wetbulb
disp('Calculating wetbulb profile, please wait.');
usePressure = sounding.pressure(kmCutoff==1);
useDew = sounding.dewpt(kmCutoff==1);
useWet = NaN(length(useTemp),1);
wetErrorCount = 0;
for c = 1:length(useTemp)
    try
        [useWet(c)] = wetbulb(usePressure(c),useDew(c),useTemp(c));
    catch ME %#ok
        wetErrorCount = wetErrorCount+1;
        %do nothing
    end
end
disp(['Wetbulb error count: ' num2str(wetErrorCount/length(useTemp)) '%'])
useWet = double(useWet); %Certain operations will not function while the data type is symbolic

%% Extra quality control to prevent jumps in the graphs
useHeight(useHeight<-150) = NaN;
useHeight(useHeight>100) = NaN;
useTemp(useTemp<-150) = NaN;
useTemp(useTemp>100) = NaN;
if all(isnan(useWet)==1)
    disp('Wetbulb calculation failed! Wetbulb profile will not be displayed.')
else
    useWet(useWet<-150) = NaN;
    useWet(useWet>100) = NaN;
end

%% Plotting

% 0C line
zeroy = [0 16];
zerox = ones(1,length(zeroy)).*0;

f = figure; %Figure is assigned to a handle for save options
leftColor = [0 0 0]; rightColor = [0 0 0];
set(f,'defaultAxesColorOrder',[leftColor; rightColor]) %Sets left and right y-axis color

plot(useTemp,useHeight,'Color',[255 128 0]./255,'LineWidth',2.4) %temperature profile
hold on
plot(zerox,zeroy,'Color',[0 0 0],'LineWidth',2) %0C line
hold on
plot(useWet,useHeight,'Color',[128 0 255]./255,'LineWidth',2.4); %wetbulb profile

% Plot settings
limits = [0 kmTop];
ylim(limits);
ax = gca;
ax.Box = 'off';
ax.FontSize = 16;
hold off
heights = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13 14 15 16 17];
ax.YTick = heights;
yyaxis right %kFt
ax.YTick = heights;
yticklabels(round(heights.*3.28084,1))
ylabel('Height in kFt')
ylim(limits);
yyaxis left %switch back to primary km axis

set(ax,'XTick',[-80 -75 -70 -65 -60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -10 -5 -2 0 2 5 10 15])

leg = legend('Temperature','Freezing','Wetbulb');
leg.FontSize = 14;
dateString = datestr(sounding.Properties.CustomProperties.valid_date_num,'mmm dd, yyyy HH UTC'); %For title
t = title({['Sounding for ' dateString],launchSite});
t.FontSize = 16;
xLab = xlabel([char(176) 'C']);
xLab.FontSize = 16;
yLab = ylabel('Height in km');
yLab.FontSize = 16;

kmCutoff_xScale = logical(useHeight <= kmTop);
useTemp_xScale = sounding.temp(kmCutoff_xScale==1);
maxLim = max(useTemp_xScale);
if maxLim+1<0
    maxLim = 0;
end
xlim([-30 maxLim+1])

%set(f,'PaperPositionMode','manual')
%set(f,'PaperUnits','inches','PaperPosition',[0 0 9 9])
%print(f,'-dpng','-r400')

end