function [time,ssh,loc]  = saveRange

% LOAD DATA
path2data = fullfile('..','..','data','processed','tideLevel_rqh_UHSLC');
% Get filenames
names = dir(fullfile(path2data,'*.mat'));
names = {names.name};
tgDat = cell(length(names),1);
% Load the actual data
for k=1:length(names)
    tgDat{k} = load(fullfile(path2data,names{k}));
end

% CLEAN AND REFORMAT THE DATA
% Pre-allocate the array to hold the data in a nicer format
[time,ssh,loc] = deal(cell(length(tgDat),1));
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
    time{k} = dt;
    ssh{k} = h;
    loc{k} = [lat lon];
end 
% Convert loc to double array
loc = cell2mat(loc);


% WRITE THE DATA
% Open the file and preallocate array for the tidal range
fid = fopen([path2data 'stationRange.txt'],'wt');
rnge = NaN(length(time),1);
for k=1:length(time)
    % Calculate the range
    rnge(k) = range(ssh{k});
    % Convert to meters
    rnge = rnge/1000;
    % Save data
    fprintf(fid,'%f %f %f\n',loc(k,1),loc(k,2),rnge(k));
end 
fclose(fid);