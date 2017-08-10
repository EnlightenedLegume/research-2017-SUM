
% Get all filenames in the data folder;
path2data = '~/research/data/raw/tideLevel_rqh_UHSLC/';
d = dir(path2data);
% Remove directories
fnames = {d(~[d.isdir]).name};
% Set path to save into
path2save = '~/research/data/processed/tideLevel_rqh_UHSLC/';

% Read data, don't save anything in RAM
for k=1:length(fnames)
    tic 
    try
        readinUHSLCTide(path2data,fnames{k},path2save);
    catch err
        err
    end 
    toc
end

