path2data = '~/research/data/processed/tideLevel_rqh_UHSLC/';

names = dir([path2data '*.mat']);
names = {names.name};
tgDat = cell(length(names),1);
for k=1:length(names)
    tgDat{k} = load([path2data names{k}]);
end

%% 
all = cell(length(tgDat),1);

for k=1:length(tgDat)
    % Assign the data to more sensible names
    t = tgDat{k}.res.time;
    h = tgDat{k}.res.ssh;
    lat = tgDat{k}.res.lat;
    lon = tgDat{k}.res.lon;
    
    % Convert the time to sensible units 
    startDate = datetime(1700,01,01,00,00,00);
    % Get the number of days
    Days = floor(t);
    % Get the remainder, multiply by 24, now in hours
    HMS = (t - Days)*24;
    Hours = floor(HMS);
    % Get remainder, multiply by 60, now in minutes
    MS = (HMS - Hours)*60;
    MINS = floor(MS);
    % Add this all to startDate
    dt = startDate + days(Days) + hours(Hours) + minutes(MINS);
    
    % Remove fill values 
    h(h<=-32750) = NaN;
    % De-mean the height (h/ssh)
    h = h-nanmean(h);
    
    % Save the data to cells
    temp = {dt,h,lat,lon};
    all{k} = temp;
end 

%% Calculate/save range and location
fid = fopen([path2data 'stationRange.txt'],'wt');
rnge = NaN(length(all),1);
for k=1:length(all)
    rnge(k) = range(all{k}{2});
    % Convert to meters
    rnge = rnge/1000;
    % Save data
    fprintf(fid,'%f %f %f\n',all{k}{3},all{k}{4},rnge(k));
end 
fclose(fid);
    

%% Plot the Data
for k=1:length(all)
    fig = figure(1);
    plot(all{k}{1},all{k}{2});
    % Format it
    grid on;
    grid minor;
    axis tight;
    xlabel('Time');
    ylabel('Tide height (millimeters)');
end
