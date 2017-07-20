% THIS SCRIPT IS FOR TESTING MATLAB CODE BEFORE FUNCTIONALIZING
% IT/FORMALIZING IT. 

%% 

% Load data 
path2data = '~/research/data/processed/webcritech/';
load([path2data 'har.mat']);
load([path2data 'stationLoc.mat']);
load([path2data 'sumHar.mat']);

% Remove station IDs
loc = stationLoc(:,2:3);

% Convert to cell
[m,n,o] = size(har);
har2cell = mat2cell(har,repmat(1,m,1),n,o);
% Calculate tide for 500 time steps (0.01 day steps);
tides = cell2mat(cellfun(@(x) predictTide([1:0.12:1000],squeeze(x)), ...
                         har2cell,'UniformOutput',0));

% Get interquartile range for each station
tideRange = range(tides,2);

% Remove NaNs
loc = loc(repmat(~isnan(nanstd(tides,1,2)),2,1));
loc = reshape(loc,[length(loc)/2,2]);
tideRange = tideRange(~isnan(nanstd(tides,1,2)));

% Save data 
fid = fopen([path2data 'stationList.txt'], 'wt');
for k=1:length(loc)
    fprintf(fid,'%f %f %f\n',loc(k,1),loc(k,2),tideRange(k));
end
fclose(fid);



%%
a = 2;
c = 2;
syms u v
x = a*cos(u)*sin(v);
y = a*sin(u)*sin(v);
z = c*cos(v);
colormap summer;
f = fsurf(x,y,z,'EdgeColor','none');
f.MeshDensity = 9;

for k=1:0.1:10
    f.ZFunction = k*c*cos(v);
    drawnow
end

%%
fig = figure('Position',[100 100 850 1100]);
a = (sumHar' - min(sumHar'))./(max(sumHar') - min(sumHar'));
%plot(har(1,:,2),a); hold on; grid on; axis tight;
hold on; grid on; axis tight;
e = errorbar(har(1,:,2),nanmedian(a,2),mad(a,1,2),'Marker','o', ...
         'LineStyle','none'); 
s = stem(har(1,:,2),nanmedian(a,2));
set(gca,'xscale','log');
set(gca,'yscale','log');

xlabel('Period (days)','FontSize',15);
ylabel('Normalized Summed Coefficient (a.u.)','FontSize',15);

saveFig(fig,'webcritechMedianCoeffs','pdf','orient','landscape', ...
        'width',26.29,'height',20.32)


