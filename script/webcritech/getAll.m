function [loc,har,sumHar] = getAll(fname);
% Function to get the harmonic constants and periods from the
% Webcritech website. Takes a .txt file with station IDs and
% outputs their locations, harmonic constants/period and the sum of
% the harmonic constants. Saves these variables as
% webcritechStationLoc.mat, webcritechHar.mat and
% webcritechSumHar.mat.
%
% INPUTS
% [loc,har,sumHar] = getAll(fname)
%         Takes the name of a file with station IDs (as a string)
%         and downloads the respective webpages and parses the
%         locations and harmonics from them.
%
% OUTPUTS
% loc     2xN double matrix. First col is latitude, second col is
%         longitude. N is the number of stations found. Currently,
%         Webcritech lists lat/lon in N and E, so Southern and
%         Western coordinates are negative.
% har     Nx70x4 double matrix. Each station has a page. First col
%         is harmonic number (0-69), second col is period (in
%         days), third col is cosine coefficient, fourth col is
%         sine coefficient. N is the number of stations found.
% sumHar  Nx70 double matrix. N is the number of the stations
%         found. Each col is the square root of the sum of the
%         squares of the sinusoidal coefficients. Summed across
%         each period, hence 70 cols.
    
% Created by Benjamin Huang on 07/03/2017
    
ids = importdata(fname);
% Remove known broken links
ids = ids(ids~=2416);
ids = ids(ids~=2415);
ids = ids(ids~=2575);
ids = ids(ids~=2574);
ids = ids(ids~=2437);
ids = ids(ids~=2459);
ids = ids(ids~=2477);

% Preallocate arrays for speed
loc = NaN(length(ids),2);
har = NaN(length(ids),70,4);

% Get all the locations and harmonics
for k=1:length(ids)
    try
    [loc(k,:),har(k,:,:)] = parsePred(ids(k));
    catch
        sprintf('ID %i failed',ids(k))
    end
    sumHar(k,1:70) = sqrt(har(k,:,3).^2+har(k,:,4).^2);
end

% Concatenate locations with IDs
stationLoc = [ids,loc];

path2data = '~/research/data/processed/webcritech/'; 
save([path2data 'stationLoc.mat'],'stationLoc');
save([path2data 'har.mat'],'har');
save([path2data 'sumHar.mat'],'sumHar');