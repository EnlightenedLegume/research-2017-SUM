function res = readinUHSLCTide(path2data,fname,path2save)
% Function to read research quality, hourly tide data from
% University of Hawaii's THREDDS server. Data is assumed to be in
% OPeNDAP's ascii format
% INPUT
% fname: File name to read in

% Open file
fid = fopen([path2data fname]);
% Get the first line
lin = fgetl(fid);
% Check if file is empty--exit if so
if isnumeric(lin)
    error(['File is empty' fname]);
end

% Loop until line of '-' are found
while isempty(findstr(lin,'----'))
    lin = fgetl(fid);
end

% Get next line,
lin = fgetl(fid);
% Find the number of time data points
numTime = cellfun(@str2num,regexp(lin,'\d*','match'));

% Get next line, all time data points
lin = fgetl(fid);
% Split along comma-space
time = regexp(lin,', ','split');
% Convert to number and array format
time = cellfun(@str2num,time)';

% Get next line, ignore it (it's blank)
fgetl(fid);
% Get next line, ignore it (unimportant label)
fgetl(fid);

% Get next line and convert to number (depth)
depth = str2num(fgetl(fid));

% Get next two lines and ignore again
fgetl(fid); fgetl(fid);

% Get next line and convert to number (lat)
lat = str2num(fgetl(fid));

% Get next two lines and ignore again
fgetl(fid); fgetl(fid);

% Get next line and convert to number (lon)
lon = str2num(fgetl(fid));

% Get next two lines and ignore again
fgetl(fid);
fgetl(fid);

% Pre-allocate array for speed
ssh = NaN(length(time),1);
% Read in sea surface height--each data point is a separate line
lin = fgetl(fid);
% Use index in case time array is shorter or longer than actual data
k = 1;
% Using a while loop here allows handling of unexpected cases where
% the data is shorter or longer than expected
while ~strcmp(lin,'');
    ssh(k) = str2num(cell2mat(regexp(lin,' [-]?\d*','match')));
    k = k + 1;
    lin = fgetl(fid);
end 

% Save data
res = struct('time',time,'depth',depth,'lat',lat,'lon',lon,'ssh', ...
             ssh);
% Get station ID
stationID = regexp(fname,'\d*[A-F]','match');
stationID = stationID{1};
% Save to <stationID>.mat
[path2save stationID '.mat']
save(fullfile(path2save,[stationID '.mat']),'res');

fclose(fid);
