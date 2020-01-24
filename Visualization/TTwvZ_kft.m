%%TTwvZ_kft
    %Function to plot the height profile of temperature and wetbulb temperature
    %given an input date and soundings structure. Additionally, allows for
    %user control of the maximum height plotted. Height is plotted in both
    %km and in kilofeet. Written for aircraft flight planning support
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
    %NOTE: dateString and launchname are controlled WITHIN code and not at
    %the inputs for now.
    %
    %
    %Version Date: 1/24/2020
    %Last major revision: 1/24/2020
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also wetbulb
    %

function [f] = TTwvZ_kft(sounding,kmTop)
% Confine all data to between surface and maximum requested height
useHeight = sounding.height;
useHeight = useHeight./1000;
kmCutoff = logical(useHeight <= kmTop+1); %Find indices of readings where the height less than the maximum height requested, plus a bit for better plotting
useTemp = sounding.temp(kmCutoff==1);
useHeight = sounding.height(kmCutoff==1);
useHeight = useHeight./1000;
disp('Calculating wetbulb profile, please wait.');
usePressure = sounding.pressure(kmCutoff==1);
useDew = sounding.dewpt(kmCutoff==1); %Needed for wetbulb calculation
useWet = NaN(length(useTemp),1);
for c = 1:length(useTemp)
    try
        [useWet(c)] = wetbulb(usePressure(c),useDew(c),useTemp(c));
    catch ME %#ok
        %do nothing
        %errors in wetbulb calculation will be dealt with later
    end
end
useWet = double(useWet); %Certain operations will not function while the data type is symbolic

% Extra quality control to prevent jumps in the graphs
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

% 0C line
freezingy = [0 16];
freezingx = ones(1,length(freezingy)).*0;

% Plotting
f = figure; %Figure is assigned to a handle for save options
leftColor = [0 0 0]; rightColor = [0 0 0];
set(f,'defaultAxesColorOrder',[leftColor; rightColor]) %Sets left and right y-axis color

plot(useTemp,useHeight,'Color',[255 128 0]./255,'LineWidth',2.4) %TvZ
hold on
plot(freezingx,freezingy,'Color',[0 0 0],'LineWidth',2) %Freezing line
hold on
plot(useWet,useHeight,'Color',[128 0 255]./255,'LineWidth',2.4); %TwvZ

% Plot settings
limits = [0 kmTop];
ylim(limits);
ax = gca;
ax.Box = 'off';
ax.FontSize = 16;
hold off
heights = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13];
ax.YTick = heights;
yyaxis right
ax.YTick = heights;
yticklabels(round(heights.*3.28084,1))
ylabel('Height in kFt')
ylim(limits);
yyaxis left

set(ax,'XTick',[-80 -75 -70 -65 -60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -10 -5 -2 0 2 5 10 15])

leg = legend('Temperature','Freezing','Wetbulb');
leg.FontSize = 14;
dateString = datestr(datenum(2020,1,24,0,0,0),'mmm dd, yyyy HH UTC'); %For title
launchname = 'Albany';
t = title({['Sounding for ' dateString],launchname});
t.FontSize = 16;
xLab = xlabel([char(176) 'C']);
xLab.FontSize = 16;
yLab = ylabel('Height in km');
yLab.FontSize = 16;

kmCutoff_xScale = logical(useHeight <= kmTop); %Find indices of readings where the height less than the maximum height requested, plus a bit for better plotting
useTemp_xScale = sounding.temp(kmCutoff_xScale==1);
% minLim = min(useTemp_xScale);
maxLim = max(useTemp_xScale);
if maxLim+1<0
    maxLim = 0;
end
% xlim([minLim-1 maxLim+1])
xlim([-30 maxLim+1])
%xlim([-12,5])
%Max air temperature will always be greater than max wetbulb temperature:
%Either both have been recorded, in which case air temperature is always
%greater than wetbulb by definition, or air temperature stopped recording,
%in which case the wetbulb cannot be calculated anyway.
    
% Common settings for making poster graphics from Long Island
%set(ax,'XTick',[-30 -15 -10 -6 -4 -3 -2 -1 0 1 2 3 4 6 10 15])
%xlim([-10 16]) %Typical to fix axis for poster graphics; this usually covers most cases from Long Island

% Optional save options
%print(f,'-dpng','-r300')
% set(f,'PaperPositionMode','manual')
% set(f,'PaperUnits','inches','PaperPosition',[0 0 9 9])
% print(f,'-dpng','-r400')

end