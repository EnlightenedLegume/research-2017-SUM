function validids = findValidWebcritech(minid,maxid)
% Finds valid station IDs in the range from min to max

validids = [];
for i=minid:maxid
    url = ['http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/' ...
           'TideGaugeDetails/' num2str(i)];
    J = java.net.URL(url);
    conn = openConnection(J);
    status = getResponseCode(conn);
    if status == 200
        validids = [validids;i];
    end
end
