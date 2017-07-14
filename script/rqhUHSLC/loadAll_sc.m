% THIS FILE IS FOR CODE THAT HAS NOT BEEN FUNCTIONALIZED/FORMALIZED

% Get all filenames in the data folder;
path2data = '~/research/data/raw/tideLevel_rqh_UHSLC/';
d = dir(path2data);
% Remove directories
fnames = {d(~[d.isdir]).name};
% Set path to save into
path2save = '~/research/data/processed/tideLevel_rqh_UHSLC/';

% NVM TRYING IT WITHOUT SAVING ANYTHING IN RAM
% Pre-allocate array for speed
%time = cell(length(fnames),1);
%depth = cell(length(fnames),1);
%lat = cell(length(fnames),1);
%lon = cell(length(fnames),1);
%ssh = cell(length(fnames),1);

% Read data, don't save anything in RAM
for k=1:length(fnames)
    tic 
    try
        readinUHSLCTide(path2data,fnames{k},path2save);
    catch 
    end 
    toc
end

