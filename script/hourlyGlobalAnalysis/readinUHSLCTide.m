function readinUHSLCTide(fname)
% Function to read research quality, hourly tide data from
% University of Hawaii's THREDDS server. Data is assumed to be in
% OPeNDAP's ascii format
% INPUT
% fname: String of file name to load

% Open file
fid = fopen('230A.txt');
% Get the first line
lin = fgetl(fid);
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
time = cellfun(@str2num,time);

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





fclose(fid);
