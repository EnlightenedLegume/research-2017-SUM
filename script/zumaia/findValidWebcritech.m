function findValidWebcritech(minid,maxid)
% Finds valid station IDs in the range from min to max

try
    url = ['http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/' ...
           'TideGaugeDetails/' num2str(stationid)];
    webread(url);
catch
q
end
