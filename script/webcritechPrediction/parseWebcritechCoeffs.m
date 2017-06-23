function coeffs = parseWebcritechCoeffs(varargin)
% Used for parsing harmonic constants from the eu website
% Webcritech. Base URL is
% http://webcritech.jrc.ec.europa.eu/SeaLevelsDb/Home/TideGaugeDetails
%
% INPUTS
% coeffs = parseWebcritechCoeffs('id',stationId)
%         Takes a station's id (<stationId>) and parses the
%         corresponding station's harmonic constants into coeffs
% coeffs = parseWebcritechCoeffs('string',webpage)
%         Takes a station's detail webpage (HTML source as a string
%         stored in (<webpage>)) and parses harmonic constants into
%         coeffs. Note that 'string' mode does not necessarily need
%         the full webpage--part of it will do
% OUTPUTS
% coeffs  Nx4 double matrix. Currently (June 2017), Webcritech
%         has calculated harmonics 0 through 69, giving N =
%         70. First column is the harmonic number (0 through N),
%         second column is the period (days), third column is the
%         cosine coefficient, and fourth column is the sine
%         coefficient. 


% Created 2017/06/22 by Benjamin Huang
%     * Initial version, supports only a station id
% Updated on 2017/06/23 Benjamin Huang 
%     * Handle an ID or string of HTML code

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
    % Expression for any row in the table
    exp = ['<tdclass="text-centertext-grid">[^<]*</td><tdclass=' ...
           '"text-righttext-grid">[^<]*</td><tdclass="text-' ...
           'righttext-grid">[^<]*</td><tdclass="text-righttext-' ...
           'grid">[^<]*</td>'];
    % Parse rows into separate entries in cell
    wbpgNum = regexp(wbpgNos,exp,'match');
    % Only keep numbers
    coeffsStr = regexp(wbpgNum,'\d+\.?\d*(E[+-]\d*)?','match');
    % Convert cell of strings to array of doubles
    coeffs = reshape(cell2mat(cellfun(@(x) cellfun(@str2num,x), ...
                                      coeffsStr,'UniformOutput', ...
                                      false)),4,[])';    
  case 'string'
    wbpg = varargin{2};
    wbpgNos = regexprep(wbpg,'\s*','');
    exp = ['<tdclass="text-centertext-grid">[^<]*</td><tdclass=' ...
           '"text-righttext-grid">[^<]*</td><tdclass="text-' ...
           'righttext-grid">[^<]*</td><tdclass="text-righttext-' ...
           'grid">[^<]*</td>'];
    wbpgNum = regexp(wbpgNos,exp,'match');
    coeffsStr = regexp(wbpgNum,'\d+\.?\d*(E[+-]\d*)?','match');
    coeffs = reshape(cell2mat(cellfun(@(x) cellfun(@str2num,x), ...
                                      coeffsStr,'UniformOutput', ...
                                      false)),4,[])';
end
end
