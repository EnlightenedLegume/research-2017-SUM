function loc = parseWebcritechLoc(varargin)
% Function to pull latitude and longitude from Webcritech 
% Base URL is
% http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/TideGaugeDetails
% 
% INPUTS 
% loc = parseWebcritechLoc('id',stationId)
%        Takes a station's id (<stationId>) and parses the
%        station's latitude and longitude from the webpage directly
% loc = parseWebcritechLoc('string',webpage)
%        Takes a station's detail webpage (HTML source as a string
%        stored in <webpage>) and parses the latitude and longitude
%        from it. Note that 'string' mode does not necessarily need
%        the full webpage, only the part with the latitude and
%        longitude
% OUTPUTS 
% loc     2x1 double matrix. First is latitude (N/S) and second is
%         longitude (E/W). Currently, Webcritech lists lat/lon
%         always in N and E, so Southern and Western coordinates
%         are negative
    
% Created by Benjamin Huang on 06/23/2017

    
varmode = varargin{1};
switch varmode
  case 'id'
    % Construct URL
    url = ['http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/' ...
           'TideGaugeDetails/',num2str(varargin{2})]
    % Download html source
    wbpg = webread(url);
    % Remove white space
    wbpgNos = regexprep(wbpg,'\s*','');
    % Regexp to pull only the line that contains lat/lon
    exp = '<td>Lat/Lon</td><td>[^<]*</td>';
    locHTML = regexp(wbpgNos,exp,'match');
    % Remove extraneous HTML tags and text
    locStr = regexp(locHTML,'\d\.\d*','match');
    loc = cell2mat(cellfun(@(x) cellfun(@str2num,x),locStr, ...
                           'UniformOutput',false));
  case 'string'
    wbpg = varargin{2};
    % Remove white space
    wbpgNos = regexprep(wbpg,'\s*','');
    % Regexp to pull only the line that contains lat/lon
    exp = '<td>Lat/Lon</td><td>[^<]*</td>';
    locHTML = regexp(wbpgNos,exp,'match');
    % Remove extraneous HTML tags and text
    locStr = regexp(locHTML,'\d\.\d*','match');
    loc = cell2mat(cellfun(@(x) cellfun(@str2num,x),locStr, ...
                           'UniformOutput',false));    
end

